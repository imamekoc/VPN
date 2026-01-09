## 2024-05-22 - [Optimizing Shell Script Loops]
**Learning:** Shell scripts that perform file I/O (like `cat`, `grep`, `sed`) inside nested loops can be exponentially slow. Reading a file once into a variable (if size permits) and processing it in memory is vastly superior.
**Action:** Always check for `cat file` inside loops. Replace with `variable=$(cat file)` outside the loop and process the variable.
