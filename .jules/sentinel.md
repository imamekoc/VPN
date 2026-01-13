## 2024-05-23 - Hardcoded Secrets in Shell Scripts
**Vulnerability:** Found hardcoded Cloudflare API keys and emails in `cf.sh` and `domaingratis` scripts. These secrets were assigned directly to variables `CF_ID` and `CF_KEY`.
**Learning:** Shell scripts designed for easy installation ("one-click") often prioritize convenience over security by embedding the author's credentials. This anti-pattern exposes the author's infrastructure to takeover.
**Prevention:** Always verify installation scripts for hardcoded secrets. Use environment variables (checked with `[[ -z "${VAR}" ]]`) as the primary configuration method, falling back to `read -s` prompts for interactive use. Never assume "setup" scripts are safe to run or commit without review.
