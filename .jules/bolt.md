## 2025-05-15 - [Legacy Script Optimization]
**Learning:** Legacy Bash scripts often duplicate network calls (e.g., fetching IP or permissions) in separate variables.
**Action:** Consolidate `curl` calls into a single fetch, store in a variable, and parse locally using `awk`/`grep`.
