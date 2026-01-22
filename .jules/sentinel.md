## 2024-05-23 - Hardcoded Cloudflare Credentials
**Vulnerability:** Hardcoded Cloudflare Email and API Key found in `cf.sh` and `domaingratis`.
**Learning:** Legacy VPS setup scripts often contain hardcoded credentials from the original author to simplify the "one-click" experience for users, prioritizing ease of use over security.
**Prevention:** Refactor scripts to check for environment variables (`CF_ID`, `CF_KEY`) first, and fall back to secure interactive prompts (`read -s`) only if variables are missing.
