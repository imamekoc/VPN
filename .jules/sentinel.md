# Sentinel's Journal

## 2024-05-23 - Widespread Insecure Permissions
**Vulnerability:** Found multiple instances of `chmod 777` applied to system binaries (`/usr/bin/menu`, `/usr/sbin/dns-server`) and user configuration files (`/home/vps/public_html/*.conf`).
**Learning:** The scripts prioritized ease of access over security, likely to avoid permission errors during execution or file transfer. This allows any user on the system to modify critical system commands and steal/modify sensitive VPN configs.
**Prevention:** Use `chmod 755` for executables (rwxr-xr-x) and `chmod 644` for data files (rw-r--r--). Never use `777` unless absolutely necessary and scoped to a specific temporary directory with no execution privileges.
