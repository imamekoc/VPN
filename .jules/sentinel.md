## 2024-05-22 - Hardcoded Credentials in Setup Scripts
**Vulnerability:** Found hardcoded Cloudflare API keys and emails directly in `cf.sh` and `domaingratis`.
**Learning:** These scripts appear to be distributed as-is, implying that users might be using the author's credentials or simply copying the insecure pattern. The codebase relies on `wget` to fetch other scripts, propagating this insecurity.
**Prevention:** Always use environment variables for secrets. In shell scripts, check for the variable and prompt interactively (using `read -s`) if missing. Never commit keys to the repo.
