## 2024-05-22 - Redundant External Calls in Interactive Menus
**Learning:** Interactive menu scripts (`menu.sh`) were performing multiple synchronous `curl` calls (IP, ISP, License) on *every* load. Since menus are often reloaded recursively, this creates a massive cumulative delay and potential rate-limiting issues.
**Action:** Always cache semi-static data like Public IP and ISP info in a temporary file and verify freshness before fetching again. Consolidate redundant calls.
