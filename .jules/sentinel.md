## 2024-05-23 - Hardcoded Cloudflare Credentials in Shell Scripts
**Vulnerability:** Hardcoded Cloudflare API keys and email addresses were found in `cf.sh` and `domaingratis`.
**Learning:** These scripts appear to be "one-click" setup scripts distributed to users who might not know how to set up environment variables, leading developers to hardcode their own or shared credentials for ease of use.
**Prevention:** Use environment variables with interactive prompts as a fallback. Never commit personal API keys to public repositories. Scan repositories for high-entropy strings or known key patterns.
