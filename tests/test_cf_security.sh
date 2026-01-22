#!/bin/bash
set -e

# Create a temporary directory for the test
TEST_DIR=$(mktemp -d)
cp cf.sh "$TEST_DIR/cf.sh"
cd "$TEST_DIR"

# Mock binaries
mkdir bin
export PATH="$TEST_DIR/bin:$PATH"

cat > bin/wget << 'EOF'
#!/bin/bash
if [[ "$@" == *"-qO- ipinfo.io/ip"* ]]; then
  echo "1.2.3.4"
fi
EOF
chmod +x bin/wget

cat > bin/apt << 'EOF'
#!/bin/bash
# Mock apt
echo "Mock apt installed"
EOF
chmod +x bin/apt

cat > bin/curl << 'EOF'
#!/bin/bash
# Log curl arguments to verify credentials usage
echo "curl args: $@" >> curl.log

# Handle ifconfig.me
if [[ "$@" == *"-sS ifconfig.me"* ]]; then
  echo "1.2.3.4"
  exit 0
fi

# Handle Cloudflare API calls
echo '{"result": [{"id": "mock_zone_id"}], "success": true, "errors": [], "messages": []}'
EOF
chmod +x bin/curl

cat > bin/jq << 'EOF'
#!/bin/bash
# Consume stdin to avoid SIGPIPE in the piped process (curl)
cat > /dev/null
# Simple mock that just returns a fixed ID
echo "mock_id"
EOF
chmod +x bin/jq

# Mock other commands
for cmd in mkdir cp rm sleep genssl clear; do
  echo -e "#!/bin/bash\n:" > "bin/$cmd"
  chmod +x "bin/$cmd"
done

# Fix paths in cf.sh
sed -i 's|/root/|./root_|g' cf.sh
sed -i 's|/etc/xray|./etc_xray|g' cf.sh
sed -i 's|/usr/bin/xray|./usr_bin_xray|g' cf.sh
sed -i 's|/var/lib/scrz-prem/|./var_lib_|g' cf.sh

mkdir -p ./root_
mkdir -p ./etc_xray
mkdir -p ./usr_bin_xray
mkdir -p ./var_lib_

echo "--- Test 1: Env Vars Provided ---"
# Clear log
rm -f curl.log
# Run with env vars.
# Pipe newline for the final read prompt.
export CF_ID="test_user@example.com"
export CF_KEY="test_api_key_123"
set +e
echo "" | bash cf.sh
RET=$?
set -e

if [[ $RET -ne 0 ]]; then
  echo "Script failed with exit code $RET"
  exit 1
fi

if grep -q "X-Auth-Email: test_user@example.com" curl.log; then
  echo "SUCCESS: Env Var Email used."
else
  echo "FAILURE: Env Var Email NOT used."
  cat curl.log
  exit 1
fi

if grep -q "X-Auth-Key: test_api_key_123" curl.log; then
  echo "SUCCESS: Env Var Key used."
else
  echo "FAILURE: Env Var Key NOT used."
  cat curl.log
  exit 1
fi

# Check that the hardcoded values are NOT used (sanity check)
if grep -q "bukhorimukhammad@gmail.com" curl.log; then
   echo "FAILURE: Hardcoded Email still being used!"
   exit 1
fi

echo "--- Test 2: Prompt for Credentials ---"
# Clear log
rm -f curl.log
unset CF_ID
unset CF_KEY

# Provide inputs: Email, Key, then Newline for final read
# The script asks for Email, then Key.
# Then runs... then asks for "Press any key"
INPUT="prompt_user@example.com
prompt_key_456
"

set +e
echo -e "$INPUT" | bash cf.sh
RET=$?
set -e

if [[ $RET -ne 0 ]]; then
  echo "Script failed with exit code $RET"
  exit 1
fi

if grep -q "X-Auth-Email: prompt_user@example.com" curl.log; then
  echo "SUCCESS: Prompted Email used."
else
  echo "FAILURE: Prompted Email NOT used."
  cat curl.log
  exit 1
fi

if grep -q "X-Auth-Key: prompt_key_456" curl.log; then
  echo "SUCCESS: Prompted Key used."
else
  echo "FAILURE: Prompted Key NOT used."
  cat curl.log
  exit 1
fi

echo "ALL TESTS PASSED"
