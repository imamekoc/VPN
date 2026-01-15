#!/bin/bash
export PATH=$PWD/tests/mocks:$PATH

# Reset log
rm -f tests/curl_log.txt

# Prepare test script
cp menu.sh menu_test.sh

# 1. Remove Root Check
sed -i 's/if \[ "${EUID}" -ne 0 \]; then/if [ 1 -eq 0 ]; then/' menu_test.sh

# 2. Redirect File Paths
sed -i 's|/etc/xray/config.json|tests/mocks/files/etc/xray/config.json|g' menu_test.sh
sed -i 's|/etc/xray/domain|tests/mocks/files/etc/xray/domain|g' menu_test.sh
sed -i 's|/root/nsdomain|tests/mocks/files/root/nsdomain|g' menu_test.sh

# 3. Handle Clear (replace with true so && works)
sed -i 's/clear/true/g' menu_test.sh

# 4. Handle input
# The script ends with: read -p " Select menu : " opt
# Replace with setting opt=x (exit)
sed -i 's/read -p " Select menu : " opt/opt=x/' menu_test.sh

# 5. Remove any other blocking reads
sed -i 's/read -n 1 -s -r -p/echo/' menu_test.sh

# 6. Execute
chmod +x menu_test.sh
./menu_test.sh > tests/output.log 2>&1

# 7. Count curls
if [ -f tests/curl_log.txt ]; then
    count=$(grep -c . tests/curl_log.txt)
else
    count=0
fi
echo "Curl calls: $count"

# Display log for debugging
if [ -f tests/curl_log.txt ]; then
    cat tests/curl_log.txt
fi
