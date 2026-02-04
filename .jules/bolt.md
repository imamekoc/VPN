## 2024-05-22 - Caching Volatile Data in Shell Scripts
**Learning:** Caching remote data to disk in shell scripts (to optimize startup) creates a risk of staleness if the data is volatile (e.g., license expiration).
**Action:** Split caching strategy: cache static data (IP, ISP) to disk/env, but always fetch volatile data (license) fresh. Optimize the fresh fetch by consolidating multiple requests (Name + Exp) into a single request.
