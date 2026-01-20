## 2026-01-20 - Redundant API Calls in Interactive Menus
**Learning:** Legacy Bash menus often re-execute initialization logic (like fetching IPs) on every loop/recursion. Consolidating these into single checks cached in variables (or exported from a parent script) yields massive gains.
**Action:** Look for `menu` functions that recursively call `menu` or script files that call themselves. Move expensive `curl` or `grep` operations outside the loop or cache them.
