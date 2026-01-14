## 2024-05-22 - Hardcoded Cloudflare Secrets
**Vulnerability:** Found valid Cloudflare API keys and emails hardcoded in `cf.sh` and `domaingratis` scripts. These allow full DNS control over the affected domains.
**Learning:** Shell scripts often bypass standard security reviews because they are seen as "setup helpers" rather than application code. Credentials in scripts are easily leaked if the script is shared or committed.
**Prevention:**
1. Always use environment variables for secrets in scripts.
2. Use `read -s` to prompt for sensitive input interactively.
3. Add pre-commit hooks to scan for high-entropy strings or known key patterns.
