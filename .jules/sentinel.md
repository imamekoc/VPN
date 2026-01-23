## 2024-10-26 - Hardcoded Cloudflare Credentials
**Vulnerability:** Found valid-looking Cloudflare API credentials (email/key) hardcoded directly in `cf.sh` and `domaingratis`.
**Learning:** This repo relies on shared/hardcoded credentials for "ease of use" scripts, which is a common but dangerous pattern in VPS management "autoscripts". Users often run these blindly, exposing the original author's or other users' credentials.
**Prevention:** Always use environment variables or interactive prompts for secrets. Never commit secrets to the codebase, even for "convenience".
