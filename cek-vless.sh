#!/bin/bash
red() { echo -e "\\033[32;1m${*}\\033[0m"; }

# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
CEKEXPIRED () {
    today=$(date -d +1day +%Y-%m-%d)
    Exp1=$(curl -sS https://raw.githubusercontent.com/imamekoc/VPN/main/izin | grep $MYIP | awk '{print $3}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mSTATUS SCRIPT AKTIF...\e[0m"
    else
    echo -e "\e[31mSCRIPT ANDA EXPIRED!\e[0m";
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/imamekoc/VPN/main/izin | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
CEKEXPIRED
else
echo -e "\e[31mPermission Denied!\e[0m";
exit 0
fi
clear

echo -n >/tmp/other.txt
data=($(cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq))

echo -e "\033[1;93m─────────────────────────────────────────\033[0m"
echo -e "\e[42m      Vless User Login Account            \E[0m"
echo -e "\033[1;93m─────────────────────────────────────────\033[0m"

# ⚡ Bolt: Performance optimization
# Read log file once into memory instead of reading it N * M times in nested loops.
# Reduces disk I/O from O(N*M) to O(1).
logfile=$(tail -n 500 /var/log/xray/access.log)

for akun in "${data[@]}"; do
    if [[ -z "$akun" ]]; then
        akun="tidakada"
    fi

    # Filter lines for this user from the loaded log variable
    jum=$(echo "$logfile" | grep -w "$akun" | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq)

    if [[ -z "$jum" ]]; then
        echo >/dev/null
    else
        jum2=$(echo "$jum" | nl)
        echo "user : $akun"
        echo "$jum2"
        echo -e "\033[1;93m─────────────────────────────────────────\033[0m"
    fi
done

rm -rf /tmp/other.txt
echo ""
read -n 1 -s -r -p "Press any key to back on menu"

menu
