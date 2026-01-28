## 2026-01-28 - Hardcoded Cloudflare Credentials in Shell Scripts
**Vulnerability:** Found hardcoded Cloudflare API keys and emails in `cf.sh` and `domaingratis`.
**Learning:** The codebase relies on shell scripts for VPS setup which historically contained hardcoded secrets for ease of use.
**Prevention:** Use environment variables or interactive prompts with `read -s`.
