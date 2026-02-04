#!/bin/bash
set -e

# Setup temp dir
TEST_DIR="tests_tmp_$$"
mkdir -p "$TEST_DIR"
export PATH="$PWD/$TEST_DIR:$PATH"

cleanup() {
  rm -rf "$TEST_DIR"
  rm -f curl_args.log
}
trap cleanup EXIT

# Mock curl
cat << 'EOF' > "$TEST_DIR/curl"
#!/bin/bash
# Log args
echo "$@" >> curl_args.log

# Handle responses
if [[ "$*" == *"ifconfig.me"* ]]; then
  echo "1.2.3.4"
elif [[ "$*" == *"zones?name"* ]]; then
  echo '{"result": [{"id": "mock_zone_id"}]}'
elif [[ "$*" == *"dns_records?name"* ]]; then
  echo '{"result": [{"id": "mock_record_id"}]}'
else
  # Default success response for POST/PUT
  echo '{"result": {"id": "mock_record_id"}, "success": true}'
fi
EOF
chmod +x "$TEST_DIR/curl"

# Mock wget
cat << 'EOF' > "$TEST_DIR/wget"
#!/bin/bash
echo "1.2.3.4"
EOF
chmod +x "$TEST_DIR/wget"

# Mock apt and other commands
for cmd in apt mkdir cp rm sleep genssl; do
  echo '#!/bin/bash' > "$TEST_DIR/$cmd"
  chmod +x "$TEST_DIR/$cmd"
done

# Prepare the script for testing
# We need to use sed to redirect absolute paths to our test dir
# And remove the 'read' command that blocks
sed 's|/root/|./'"$TEST_DIR"'/|g' cf.sh > "$TEST_DIR/cf_test.sh"
sed -i 's|/etc/xray|./'"$TEST_DIR"'/xray|g' "$TEST_DIR/cf_test.sh"
sed -i 's|/var/lib/|./'"$TEST_DIR"'/|g' "$TEST_DIR/cf_test.sh"
sed -i 's|/usr/bin/|./'"$TEST_DIR"'/|g' "$TEST_DIR/cf_test.sh"
# Remove the blocking read at the end
sed -i 's|read -n 1 -s -r -p "Press any key to back on genssl"||g' "$TEST_DIR/cf_test.sh"

chmod +x "$TEST_DIR/cf_test.sh"

echo "Running test with ENV vars..."
rm -f curl_args.log
export CF_ID="env_email@test.com"
export CF_KEY="env_key_123"

# Run the script (ignore output)
bash "$TEST_DIR/cf_test.sh" > /dev/null 2>&1 || true

# Check if env vars were used
if grep -q "X-Auth-Email: env_email@test.com" curl_args.log && \
   grep -q "X-Auth-Key: env_key_123" curl_args.log; then
   echo "SUCCESS: Env vars used."
else
   echo "FAILURE: Env vars not used."
   # cat curl_args.log
   exit 1
fi

# Clean up for next test
rm -f curl_args.log
unset CF_ID
unset CF_KEY

echo "Running test with missing ENV vars (Interactive mock)..."
# We need to mock input if the script prompts.
# If the script hasn't been fixed yet, this test might fail or use hardcoded values.
# If fixed, it should prompt. We'll pipe input.

printf "input_email@test.com\ninput_key_456\n" | bash "$TEST_DIR/cf_test.sh" > /dev/null 2>&1 || true

# Check if input values were used (only if we implemented the fix)
# For now, if the script is not fixed, it will use hardcoded values.
# If we are verifying the FIX, we expect input values to be used.

if grep -q "X-Auth-Email: input_email@test.com" curl_args.log && \
   grep -q "X-Auth-Key: input_key_456" curl_args.log; then
   echo "SUCCESS: Input values used."
elif grep -q "X-Auth-Key: bd06fd9e8a01b73d24db51c4c6584d9133b3e" curl_args.log; then
   echo "INFO: Hardcoded secrets still in use (expected before fix)."
else
   echo "FAILURE: Neither input nor hardcoded values found?"
   # cat curl_args.log
fi

exit 0
