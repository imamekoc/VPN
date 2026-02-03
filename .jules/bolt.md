## 2024-05-23 - Shell Script Network Optimization
**Learning:** In Bash scripts, repeated `curl` calls to the same endpoint for different fields (e.g., via `grep` and `awk`) are a major performance bottleneck.
**Action:** Fetch the content once into a variable (`DATA=$(curl ...)`), then parse locally (`echo "$DATA" | grep ...`). ALWAYS quote the variable (`"$DATA"`) to preserve newlines for `grep`/`awk`.
