## 2025-02-04 - Hardcoded Secrets in Setup Scripts
**Vulnerability:** Found hardcoded Cloudflare API keys and emails in `cf.sh` and `domaingratis` scripts.
**Learning:** This codebase uses a pattern of "installer scripts" (like `senmenu.sh`) that download other scripts (`cf.sh`) from the raw GitHub repository. This means that even if we fix the vulnerability in the repo, existing users or users running the old installer will still pull the vulnerable code until the remote target is updated. This emphasizes the need for secure defaults in the source.
**Prevention:** Never hardcode secrets. Use environment variables (e.g. `CF_KEY`, `CF_ID`) and prompt the user interactively if they are missing, ensuring that the prompt (via `read -s`) does not log the secret.
