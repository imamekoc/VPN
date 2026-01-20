#!/bin/bash

# Test harness for domaingratis security fix

# Mock functions
mock_curl() {
    # Check if we are calling cloudflare
    if [[ "$@" == *"api.cloudflare.com"* ]]; then
        # Check if auth headers are present and valid (simplified)
        if [[ "$@" != *"X-Auth-Email: test@example.com"* ]] || [[ "$@" != *"X-Auth-Key: test_key"* ]]; then
             echo "Error: Missing or invalid credentials in curl call: $@" >&2
             return 1
        fi

        # Return a dummy JSON response
        if [[ "$@" == *"zones?name="* ]]; then
             echo '{"result": [{"id": "mock_zone_id"}], "success": true}'
        elif [[ "$@" == *"dns_records?name="* ]]; then
             # simulate existing record or empty
             echo '{"result": [], "success": true}'
        else
             echo '{"result": {"id": "mock_record_id"}, "success": true}'
        fi
    elif [[ "$@" == *"ifconfig.me"* ]]; then
        echo "1.2.3.4"
    else
        echo "Mock curl output"
    fi
}

mock_wget() {
    if [[ "$@" == *"ipinfo.io/ip"* ]]; then
        echo "1.2.3.4"
    fi
}

mock_apt() {
    : # Do nothing
}

mock_clear() {
    :
}

# Export mocks
export -f mock_curl
export -f mock_wget
export -f mock_apt
export -f mock_clear

# Create a temporary copy
cp domaingratis domaingratis_test
chmod +x domaingratis_test

# Replace commands with our mocks
sed -i 's/^apt /mock_apt /g' domaingratis_test
sed -i 's/ apt / mock_apt /g' domaingratis_test
sed -i 's/curl /mock_curl /g' domaingratis_test
sed -i 's/wget /mock_wget /g' domaingratis_test
sed -i 's/clear/mock_clear/g' domaingratis_test

echo "---------------------------------------------------"
echo "TEST 1: Provide credentials via Environment Variables"
echo "---------------------------------------------------"

# Input: "mysub"
export CF_ID="test@example.com"
export CF_KEY="test_key"
echo "mysub" | ./domaingratis_test > output_env.log 2>&1
EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
    if grep -q "Domain added" output_env.log; then
        echo "TEST PASS: Script ran successfully with Env Vars."
    else
        echo "TEST FAIL: Script ran but did not output success message."
        cat output_env.log
        exit 1
    fi
else
    echo "TEST FAIL: Script exited with error code $EXIT_CODE."
    cat output_env.log
    exit 1
fi

echo "---------------------------------------------------"
echo "TEST 2: Provide credentials via Prompt (simulated)"
echo "---------------------------------------------------"

unset CF_ID
unset CF_KEY

# Input: subdomain, then email, then key
# The script asks for subdomain first.
# Then prompts for Email.
# Then prompts for Key.

(echo "mysub"; echo "test@example.com"; echo "test_key") | ./domaingratis_test > output_prompt.log 2>&1
EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
    if grep -q "Domain added" output_prompt.log; then
        echo "TEST PASS: Script ran successfully with Interactive Prompts."
    else
        echo "TEST FAIL: Script ran but did not output success message."
        cat output_prompt.log
        exit 1
    fi
else
    echo "TEST FAIL: Script exited with error code $EXIT_CODE."
    cat output_prompt.log
    exit 1
fi


# Check for hardcoded secrets in the *original* file
if grep -q "CF_KEY=8b0683c1ff3f6eed8dc32a70dfd2c02c80e9f" domaingratis; then
    echo "SECURITY CHECK FAIL: Hardcoded secret still found in domaingratis."
    exit 1
else
    echo "SECURITY CHECK PASS: Hardcoded secret removed from domaingratis."
fi
