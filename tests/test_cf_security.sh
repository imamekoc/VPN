#!/bin/bash

# Create a temporary directory for the test
TEST_DIR=$(mktemp -d)
export TEST_DIR

# Create mock bin directory
MOCK_BIN="$TEST_DIR/bin"
mkdir -p "$MOCK_BIN"

# Create dummy directories to replace system paths
mkdir -p "$TEST_DIR/root"
mkdir -p "$TEST_DIR/var/lib/scrz-prem"
mkdir -p "$TEST_DIR/usr/bin/xray"
mkdir -p "$TEST_DIR/etc/xray"

# Mock wget
cat << 'EOF' > "$MOCK_BIN/wget"
#!/bin/bash
if [[ "$@" == *"-qO- ipinfo.io/ip"* ]]; then
    echo "1.2.3.4"
fi
EOF
chmod +x "$MOCK_BIN/wget"

# Mock curl
cat << 'EOF' > "$MOCK_BIN/curl"
#!/bin/bash
# Log the arguments to a file for verification
echo "curl $@" >> "$TEST_DIR/curl_calls.log"

# Return JSON based on the URL/method to satisfy jq
if [[ "$@" == *"zones?name="* ]]; then
    echo '{"result": [{"id": "mock_zone_id"}], "success": true}'
elif [[ "$@" == *"dns_records?name="* ]]; then
    echo '{"result": [{"id": "mock_record_id"}], "success": true}'
elif [[ "$@" == *"POST"* ]]; then
    echo '{"result": {"id": "mock_new_record_id"}, "success": true}'
elif [[ "$@" == *"ifconfig.me"* ]]; then
    echo "1.2.3.4"
else
    echo '{"result": [], "success": true}'
fi
EOF
chmod +x "$MOCK_BIN/curl"

# Mock apt
cat << 'EOF' > "$MOCK_BIN/apt"
#!/bin/bash
:
EOF
chmod +x "$MOCK_BIN/apt"

# Copy cf.sh and modify it
cp cf.sh "$TEST_DIR/cf_test.sh"

# Replace system paths with test paths
sed -i "s|/root|$TEST_DIR/root|g" "$TEST_DIR/cf_test.sh"
sed -i "s|/var/lib/scrz-prem|$TEST_DIR/var/lib/scrz-prem|g" "$TEST_DIR/cf_test.sh"
sed -i "s|/usr/bin/xray|$TEST_DIR/usr/bin/xray|g" "$TEST_DIR/cf_test.sh"
sed -i "s|/etc/xray|$TEST_DIR/etc/xray|g" "$TEST_DIR/cf_test.sh"

# Comment out `clear`, `sleep`, `read`, `genssl`
sed -i 's/^clear/#clear/' "$TEST_DIR/cf_test.sh"
sed -i 's/^sleep/#sleep/' "$TEST_DIR/cf_test.sh"
sed -i 's/read -n 1 -s -r -p "Press any key to back on genssl"/# read skipped/' "$TEST_DIR/cf_test.sh"
sed -i 's/^genssl/#genssl/' "$TEST_DIR/cf_test.sh"

# Add the mock bin to PATH
export PATH="$MOCK_BIN:$PATH"

# Set environment variables
export CF_ID="test_user@example.com"
export CF_KEY="test_api_key_12345"

# Run the modified script
bash "$TEST_DIR/cf_test.sh"

# Check if the environment variables were used
if grep -q "test_user@example.com" "$TEST_DIR/curl_calls.log" && \
   grep -q "test_api_key_12345" "$TEST_DIR/curl_calls.log"; then
    echo "SUCCESS: Environment credentials detected in curl calls."
else
    echo "FAILURE: Environment credentials NOT detected."
    cat "$TEST_DIR/curl_calls.log"
    exit 1
fi

# Check that the OLD hardcoded credentials are NOT used
if grep -q "bukhorimukhammad@gmail.com" "$TEST_DIR/curl_calls.log" || \
   grep -q "bd06fd9e8a01b73d24db51c4c6584d9133b3e" "$TEST_DIR/curl_calls.log"; then
    echo "FAILURE: Old hardcoded credentials DETECTED."
    exit 1
else
    echo "SUCCESS: Old hardcoded credentials NOT detected."
fi

# Cleanup
rm -rf "$TEST_DIR"
exit 0
