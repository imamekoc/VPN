#!/bin/bash
set -e

# Setup test environment
TEST_DIR=$(mktemp -d)
# Copy the script to test dir
cp domaingratis "$TEST_DIR/"
cd "$TEST_DIR"

# 1. Static Analysis: Check for hardcoded secrets
echo "Checking for hardcoded secrets..."
FAIL=0
if grep -q "CF_ID=razertech52@gmail.com" domaingratis; then
  echo "FAIL: Hardcoded CF_ID found."
  FAIL=1
fi
if grep -q "CF_KEY=8b0683c1ff3f6eed8dc32a70dfd2c02c80e9f" domaingratis; then
  echo "FAIL: Hardcoded CF_KEY found."
  FAIL=1
fi

if [ "$FAIL" -eq 1 ]; then
  echo "Static analysis failed."
  exit 1
fi

# 2. Dynamic Analysis: Run with mocks
# Create mocks
cat > curl << 'EOF'
#!/bin/bash
# Log arguments to verify what was called
echo "curl args: $@" >> curl.log

# Return valid JSON to satisfy jq
echo '{"result": [{"id": "mock_id"}], "success": true}'
EOF
chmod +x curl

cat > wget << 'EOF'
#!/bin/bash
echo "1.2.3.4"
EOF
chmod +x wget

cat > apt << 'EOF'
#!/bin/bash
:
EOF
chmod +x apt

cat > clear << 'EOF'
#!/bin/bash
:
EOF
chmod +x clear

cat > sleep << 'EOF'
#!/bin/bash
:
EOF
chmod +x sleep

# Export mocks to path
export PATH="$TEST_DIR:$PATH"

# Run the script with env vars
export CF_ID="test@example.com"
export CF_KEY="testkey123"

# We need to feed input to the script because it has 'read -p "Mau subdomain apa..."'
# We'll feed "mysub"
echo "mysub" | ./domaingratis > output.log 2>&1 || true

# Check if curl was called with the env var values
if grep -q "X-Auth-Email: test@example.com" curl.log; then
  echo "PASS: CF_ID env var was used."
else
  echo "FAIL: CF_ID env var was NOT used. Content of curl.log:"
  cat curl.log
  exit 1
fi

if grep -q "X-Auth-Key: testkey123" curl.log; then
  echo "PASS: CF_KEY env var was used."
else
  echo "FAIL: CF_KEY env var was NOT used."
  exit 1
fi

echo "All tests passed!"
