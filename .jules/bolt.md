## 2025-10-21 - [Dead Code Permission Checks]
**Learning:** Legacy scripts (`menu-vmess.sh`) contain copy-pasted permission check logic (`PERMISSION`, `BURIQ`, network calls to Google/GitHub) that is completely unused in the execution flow but runs synchronously on startup, causing ~300ms+ delay.
**Action:** Use `grep` to trace usage of such functions and variables (`$Name`, `$biji`). If confirmed unused, remove them to eliminate network bottlenecks.
