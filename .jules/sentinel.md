## 2024-10-26 - Shared Credentials for Ease of Use
**Vulnerability:** Hardcoded Cloudflare credentials and domain in `cf.sh` and `domaingratis`.
**Learning:** The application was designed to use a shared Cloudflare account for all users to generate subdomains, creating a massive security risk where any user could revoke or abuse the shared account. This highlights a dangerous trade-off between "one-click setup" convenience and fundamental security.
**Prevention:** Require users to provide their own credentials and domain. Never embed shared secrets in distributed scripts for the sake of convenience.
