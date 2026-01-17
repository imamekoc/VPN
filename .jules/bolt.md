## 2026-01-17 - [Shell Script Network Redundancy]
**Learning:** Shell scripts in this repo often fetch the same remote resource multiple times via `curl` (e.g., getting IP address, downloading permission lists). This causes significant latency (seconds) on menu loads.
**Action:** Always capture remote content into a variable first, then parse locally using `grep`/`awk`. Do not grep directly from curl output if you need multiple fields from the same source.
