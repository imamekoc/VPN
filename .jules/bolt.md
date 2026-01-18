## 2024-05-23 - [Subshell State Persistence in Bash Testing]
**Learning:** When writing tests that mock functions (like `curl`) inside command substitutions `$(...)`, variable changes (counters) inside the mock are lost because they run in a subshell.
**Action:** Use a temporary file to store state (like call counts) when mocking commands that are called within `$(...)` or pipelines, then read the file in the parent test script.
