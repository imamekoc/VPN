#!/bin/bash

# Define files to check
FILES=(
    "setupku.sh"
    "updateyes.sh"
    "backup/strt.sh"
    "autoscript-ssh-slowdns-main/wslow2.sh"
)

FAILED=0

echo "Checking for 'chmod 777'..."

for file in "${FILES[@]}"; do
    if grep -q "chmod 777" "$file"; then
        echo "FAILED: Found 'chmod 777' in $file"
        FAILED=1
    else
        echo "PASSED: No 'chmod 777' in $file"
    fi
done

echo ""
echo "Checking for correct permissions..."

# Check setupku.sh for chmod +x vpn.sh
if grep -q "chmod +x vpn.sh" "setupku.sh"; then
    echo "PASSED: setupku.sh uses 'chmod +x vpn.sh'"
else
    echo "FAILED: setupku.sh does not use 'chmod +x vpn.sh'"
    FAILED=1
fi

# Check updateyes.sh for chmod 755
if grep -q "chmod 755 /usr/bin/menu" "updateyes.sh"; then
    echo "PASSED: updateyes.sh uses 'chmod 755'"
else
    echo "FAILED: updateyes.sh does not use 'chmod 755'"
    FAILED=1
fi

# Check backup/strt.sh for chmod 644
if grep -q "chmod 644 /home/vps/public_html/" "backup/strt.sh"; then
    echo "PASSED: backup/strt.sh uses 'chmod 644'"
else
    echo "FAILED: backup/strt.sh does not use 'chmod 644'"
    FAILED=1
fi

# Check wslow2.sh for chmod 755
if grep -q "chmod 755 /usr/sbin/dns-server" "autoscript-ssh-slowdns-main/wslow2.sh"; then
    echo "PASSED: wslow2.sh uses 'chmod 755'"
else
    echo "FAILED: wslow2.sh does not use 'chmod 755'"
    FAILED=1
fi

if [ $FAILED -eq 0 ]; then
    echo ""
    echo "All checks passed!"
    exit 0
else
    echo ""
    echo "Some checks failed!"
    exit 1
fi
