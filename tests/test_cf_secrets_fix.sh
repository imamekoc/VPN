#!/bin/bash

# Setup temp environment
TEST_DIR=$(mktemp -d)
cp "$(dirname "$0")/../cf.sh" "$TEST_DIR/cf_test.sh"

# Mock sensitive paths
sed -i "s|/root/|$TEST_DIR/root/|g" "$TEST_DIR/cf_test.sh"
sed -i "s|/etc/|$TEST_DIR/etc/|g" "$TEST_DIR/cf_test.sh"
sed -i "s|/usr/bin/|$TEST_DIR/bin/|g" "$TEST_DIR/cf_test.sh"
sed -i "s|/var/lib/|$TEST_DIR/var/lib/|g" "$TEST_DIR/cf_test.sh"

# Create mock directories
mkdir -p "$TEST_DIR/root"
mkdir -p "$TEST_DIR/etc/xray"
mkdir -p "$TEST_DIR/bin/xray"
mkdir -p "$TEST_DIR/var/lib/scrz-prem"

# Create mocks
mkdir -p "$TEST_DIR/mocks"
export PATH="$TEST_DIR/mocks:$PATH"

# Mock apt
echo '#!/bin/bash' > "$TEST_DIR/mocks/apt"
chmod +x "$TEST_DIR/mocks/apt"

# Mock wget (return IP)
echo '#!/bin/bash
if [[ "$*" == *ipinfo.io* ]]; then
  echo "1.2.3.4"
else
  echo ""
fi' > "$TEST_DIR/mocks/wget"
chmod +x "$TEST_DIR/mocks/wget"

# Mock curl
# We need to handle Cloudflare API calls
echo '#!/bin/bash
# Log arguments for verification
echo "curl args: $*" >> "'$TEST_DIR'/curl.log"

if [[ "$*" == *ifconfig.me* ]]; then
  echo "1.2.3.4"
elif [[ "$*" == *zones?name=* ]]; then
  echo "{\"result\": [{\"id\": \"mock_zone_id\"}]}"
elif [[ "$*" == *dns_records?name=* ]]; then
  echo "{\"result\": [{\"id\": \"mock_record_id\"}]}"
elif [[ "$*" == *dns_records* ]]; then
  # POST or PUT
  echo "{\"result\": {\"id\": \"new_record_id\"}}"
else
  echo "{}"
fi' > "$TEST_DIR/mocks/curl"
chmod +x "$TEST_DIR/mocks/curl"

# Mock jq
echo '#!/bin/bash
# Real jq is needed for the script to work if it parses JSON
# We assume jq is installed in the system, but if not we might need a dummy.
# For now, let pass through to real jq if available, or a simple mock.
if command -v /usr/bin/jq >/dev/null; then
    /usr/bin/jq "$@"
else
    # Simple mock for specific keys if real jq is missing
    cat > /dev/null
    echo "mock_id"
fi' > "$TEST_DIR/mocks/jq"
chmod +x "$TEST_DIR/mocks/jq"

# Mock clear
echo '#!/bin/bash' > "$TEST_DIR/mocks/clear"
chmod +x "$TEST_DIR/mocks/clear"

# Mock genssl (last command in script)
echo '#!/bin/bash' > "$TEST_DIR/mocks/genssl"
chmod +x "$TEST_DIR/mocks/genssl"

# Prepare inputs
# The script might prompt. We will feed inputs via pipe if needed.
# But initially, we want to test if it uses ENV vars.

export CF_ID="env_user@test.com"
export CF_KEY="env_key_123"
export DOMAIN="env-domain.com"

echo "Running cf_test.sh with ENV vars..."
# We expect it NOT to prompt if env vars are set (after our fix)
# But before fix, it uses hardcoded values.

# Run the script
# bash "$TEST_DIR/cf_test.sh" > "$TEST_DIR/output.log" 2>&1
# We allow it to fail since we haven't fixed it yet and it might have other issues
bash "$TEST_DIR/cf_test.sh" > "$TEST_DIR/output.log" 2>&1 || true

# Check curl log for usage of secrets
if grep -q "X-Auth-Email: bukhorimukhammad@gmail.com" "$TEST_DIR/curl.log"; then
    echo "FAIL: Script is using hardcoded CF_ID"
else
    if grep -q "X-Auth-Email: env_user@test.com" "$TEST_DIR/curl.log"; then
        echo "PASS: Script used ENV var CF_ID"
    else
        echo "FAIL: Script used neither hardcoded nor ENV CF_ID"
    fi
fi

if grep -q "X-Auth-Key: bd06fd9e8a01b73d24db51c4c6584d9133b3e" "$TEST_DIR/curl.log"; then
    echo "FAIL: Script is using hardcoded CF_KEY"
else
    if grep -q "X-Auth-Key: env_key_123" "$TEST_DIR/curl.log"; then
        echo "PASS: Script used ENV var CF_KEY"
    else
        echo "FAIL: Script used neither hardcoded nor ENV CF_KEY"
    fi
fi

# Cleanup
rm -rf "$TEST_DIR"
