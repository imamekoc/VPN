## 2026-01-26 - Hardcoded Cloudflare Credentials in Deployment Scripts
**Vulnerability:** Found valid-looking Cloudflare API credentials hardcoded in `cf.sh` and `domaingratis`.
**Learning:** The project relies on sharing scripts with embedded credentials for ease of use, likely for a specific user base or authorized resellers. This pattern suggests a lack of separation between code and configuration.
**Prevention:** Enforce environment variable usage for all secrets. Use `read -s` for interactive fallback. Never commit secrets, even for "easy setup" scripts.
