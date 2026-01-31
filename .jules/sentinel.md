## 2024-05-22 - Hardcoded Credentials in Shell Scripts
**Vulnerability:** Found hardcoded Cloudflare API keys and email addresses in `cf.sh` and `domaingratis`.
**Learning:** These scripts were likely intended for personal use or specific deployments but were shared publicly without stripping secrets. The scripts are also downloaded and executed directly from GitHub by other scripts (`senmenu.sh`), propagating the risk.
**Prevention:** Always use environment variables for secrets. When sharing scripts, use placeholders or prompt for input. Use tools like `git-secrets` or pre-commit hooks to scan for high-entropy strings or known key patterns before committing.
