## 2026-01-11 - [Hardcoded Secrets]
**Vulnerability:** Found hardcoded Cloudflare API Key and Email in `cf.sh`.
**Learning:** Hardcoded credentials in installation scripts can be inadvertently committed to version control, exposing sensitive access.
**Prevention:** Use environment variables for sensitive data or prompt the user during execution. Never commit scripts with pre-filled secrets.
