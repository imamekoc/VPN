# Bolt's Journal

## 2024-05-22 - Initial Setup
**Learning:** The project consists of many Bash scripts for VPS management. Performance optimizations should focus on reducing network calls and efficient text processing.
**Action:** Focus on caching IP lookups and optimizing `curl` usage.

## 2024-05-22 - Menu Recursive Optimization
**Learning:** `menu.sh` recursively calls itself via `./menu`, causing redundant network initialization on every screen refresh. Exporting variables and checking `[[ -z "$VAR" ]]` is essential for persistent state in this pattern.
**Action:** When optimizing interactive shell scripts, check for recursive patterns and use exported variables to cache expensive initializations.
