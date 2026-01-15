## 2025-02-18 - [Legacy Bash Script Optimization]
**Learning:** Interactive Bash menus often perform synchronous network calls at the top level, causing significant lag on every reload (especially when submenus re-execute the parent script).
**Action:** Identify redundant `curl` calls and consolidate them into variables. Since these scripts often lack tests, create a temporary test harness that mocks network tools (`curl`) and strips interactive elements (`read`, `clear`) to benchmark safely.
