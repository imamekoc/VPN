## 2024-05-22 - [Network Caching Strategy]
**Learning:** Shell scripts relying on un-cached `curl` calls for initialization variables (IP, permissions) create massive UX lag (~3s per load), especially in recursive menu systems.
**Action:** Implement simple file-based caching with TTL (Time To Live) for external API calls in bash scripts. Use `source` to load cached variables.

## 2024-05-22 - [Batching API Calls]
**Learning:** `menu.sh` was making two separate requests to the same URL to grep different fields.
**Action:** Fetch the content once into a variable, then process it locally, halving the network overhead for that resource.
