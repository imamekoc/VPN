## 2024-05-22 - Hardcoded Credentials in Shell Scripts
**Vulnerability:** Found hardcoded Cloudflare API keys in `cf.sh`.
**Learning:** Scripts developed for personal automation often rely on hardcoded secrets for convenience, which becomes a critical risk when the codebase is shared or public.
**Prevention:** Enforce usage of environment variables or interactive prompts (`read -s`) for sensitive credentials. Implement pre-commit scanning for secrets.
