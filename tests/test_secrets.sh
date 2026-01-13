#!/bin/bash
# tests/test_secrets.sh

# Known secrets to look for (split to avoid detection by the script itself)
# Original: bd06fd9e8a01b73d24db51c4c6584d9133b3e
SECRET1_A="bd06fd9e8a01b73d"
SECRET1_B="24db51c4c6584d9133b3e"
SECRET1="${SECRET1_A}${SECRET1_B}"

# Original: 8b0683c1ff3f6eed8dc32a70dfd2c02c80e9f
SECRET2_A="8b0683c1ff3f6eed"
SECRET2_B="8dc32a70dfd2c02c80e9f"
SECRET2="${SECRET2_A}${SECRET2_B}"

# Original: bukhorimukhammad@gmail.com
EMAIL1="bukhorimukhammad"
EMAIL1_DOMAIN="@gmail.com"
EMAIL1_FULL="${EMAIL1}${EMAIL1_DOMAIN}"

# Original: razertech52@gmail.com
EMAIL2="razertech52"
EMAIL2_DOMAIN="@gmail.com"
EMAIL2_FULL="${EMAIL2}${EMAIL2_DOMAIN}"

SECRETS=(
  "$SECRET1"
  "$SECRET2"
  "$EMAIL1_FULL"
  "$EMAIL2_FULL"
)

FOUND=0

echo "🔍 Scanning for known hardcoded secrets..."

for secret in "${SECRETS[@]}"; do
  # exclude this script itself from the search
  if grep -r "$secret" . --exclude="test_secrets.sh" --exclude-dir=".git" --exclude-dir="tests"; then
    echo "❌ Found secret: $secret"
    FOUND=1
  fi
done

if [ $FOUND -eq 1 ]; then
  echo "❌ Secrets found in codebase!"
  exit 1
else
  echo "✅ No known secrets found."
  exit 0
fi
