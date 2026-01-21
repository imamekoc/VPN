#!/bin/bash

# Mock curl to simulate latency and return data
function curl() {
    sleep 0.2 # Simulate 200ms RTT
    for arg in "$@"; do
        if [[ "$arg" == *"ipinfo.io/ip/"* ]]; then
            echo "1.2.3.4"
            return
        elif [[ "$arg" == *"ipv4.icanhazip.com"* ]]; then
            echo "1.2.3.4"
            return
        elif [[ "$arg" == *"izin"* ]]; then
            echo "### User1 2025-01-01 1.2.3.4"
            echo "### User2 2025-01-01 5.6.7.8"
            return
        elif [[ "$arg" == *"ipinfo.io/org"* ]]; then
            echo "AS12345 Example ISP"
            return
        fi
    done
}

echo "Starting benchmark of OPTIMIZED logic..."
start_time=$(date +%s%N)

# --- OPTIMIZED LOGIC ---
# Consolidate IP fetching
export IP=$( curl -sS ipv4.icanhazip.com )
export MYIP=$IP
IPVPS=$IP

# Fetch Permission file once
IZIN_DATA=$(curl -sS https://raw.githubusercontent.com/imamekoc/VPN/main/izin)
Name=$(echo "$IZIN_DATA" | grep $MYIP | awk '{print $2}')
Exp=$(echo "$IZIN_DATA" | grep $MYIP | awk '{print $3}')

# Fetch ISP
ISPVPS=$( curl -s ipinfo.io/org )
# -----------------------

end_time=$(date +%s%N)
duration=$(( (end_time - start_time) / 1000000 )) # in ms

echo "Optimized logic took: ${duration} ms"
echo "IP: $IP"
echo "Name: $Name"
echo "Exp: $Exp"
echo "ISP: $ISPVPS"
