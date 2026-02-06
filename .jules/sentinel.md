## 2024-05-23 - Hardcoded Cloudflare Credentials in Helper Scripts
**Vulnerability:** Found hardcoded Cloudflare API Key and Email in `domaingratis` script.
**Learning:** Legacy scripts or "helper" scripts like `domaingratis` can be overlooked during security audits of the main application flow.
**Prevention:** Scan all shell scripts in the repository for high-entropy strings and known email patterns, not just the main entry points.
