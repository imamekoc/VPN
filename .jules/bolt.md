## 2024-05-22 - Menu Startup Latency
**Learning:** Shell scripts that recursively call themselves (like `menu.sh`) re-execute all global initialization logic on every invocation. Placing synchronous network calls (like `curl`) in the global scope causes significant interface lag during navigation.
**Action:** Move expensive global initializations into a caching block with a TTL (e.g., 60 minutes) stored in a secure location (e.g., `/etc/xray/`). This creates a "warm start" effect for recursive calls.

## 2024-05-22 - Secure Caching in Root Scripts
**Learning:** Caching data for root-level scripts in `/tmp/` is a security vulnerability (Privilege Escalation) because non-root users can pre-create the file.
**Action:** Always use root-owned directories (like `/etc/` or `/var/lib/`) for caching sensitive data or execution context in scripts running as root.
