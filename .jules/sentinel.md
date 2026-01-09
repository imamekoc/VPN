## 2026-01-09 - Hardcoded Cloudflare Credentials in Setup Script
**Vulnerability:** Found hardcoded Cloudflare API Key and Email in `cf.sh` and `domaingratis`.
**Learning:** Developers often hardcode personal credentials in setup scripts intended for public use, likely for convenience or testing, forgetting to remove them.
**Prevention:** Use environment variables or prompt for input. Never commit secrets to version control. Use tools like `git-secrets` or `trufflehog` in CI.
