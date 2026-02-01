## 2025-02-01 - Hardcoded Cloudflare Credentials in Setup Scripts
**Vulnerability:** Found valid Cloudflare API credentials (Email/Key) hardcoded in `cf.sh` and `domaingratis` scripts. These scripts appear to be used for DNS automation during VPS setup.
**Learning:** Developers often hardcode personal credentials in "template" or "installer" scripts for convenience, intending to remove them later or assuming the repo is private/ignored. In this repo, multiple scripts followed this pattern.
**Prevention:** Use environment variables or interactive prompts for credentials. Scan repositories for high-entropy strings or known API key patterns before committing.
