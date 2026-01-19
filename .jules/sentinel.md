## 2024-05-23 - Hardcoded Credentials in Setup Scripts
**Vulnerability:** Found hardcoded Cloudflare API credentials (email and global API key) in `cf.sh`. This allows anyone with access to the codebase to modify the victim's DNS records.
**Learning:** These credentials likely existed to simplify the "one-click" setup experience for users, sacrificing security for convenience. The pattern of hardcoding secrets to avoid user prompts is prevalent in legacy VPS scripts.
**Prevention:** Use environment variables for secrets. Implement a check at the start of scripts: if the environment variable is missing, prompt the user (securely using `read -s`). Never commit secrets to the repo.
