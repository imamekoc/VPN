## 2024-05-23 - Bash Network Optimization
**Learning:** Legacy Bash scripts often perform redundant `curl` requests in sequence (e.g., fetching IP multiple times from different sources). In interactive loops or recursive menus, this causes massive latency (650ms -> 13ms).
**Action:** Always check for existing environment variables (`[[ -z "$VAR" ]]`) before fetching, and consolidate multiple field extractions from a single HTTP response into one variable to parse locally.
