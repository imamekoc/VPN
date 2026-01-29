## 2024-05-23 - Hardcoded Cloudflare Credentials
**Vulnerability:** Found valid Cloudflare API keys and email addresses hardcoded in `cf.sh` and `domaingratis`.
**Learning:** Legacy scripts often duplicate credentials for ease of use or lack of central configuration management. The duplication means fixing it in one place isn't enough.
**Prevention:** Use environment variables for all secrets. Implement a scanner to detect high-entropy strings or known key patterns before committing.
