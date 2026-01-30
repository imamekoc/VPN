## 2024-05-23 - Hardcoded Cloudflare Credentials in Deployment Scripts
**Vulnerability:** Found hardcoded Cloudflare email and global API key in `cf.sh` and `domaingratis`. The script was designed for automated deployment but included the author's personal credentials.
**Learning:** Developers often hardcode secrets for their own convenience during development or "easy" setup for others, forgetting to remove them before publishing. "Auto-install" scripts are a common vector for this.
**Prevention:** Always use environment variables for secrets in scripts (`${VAR:-}`). Implement pre-commit hooks to scan for high-entropy strings or known API key patterns (like Cloudflare's hex keys).
