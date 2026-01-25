# Sentinel's Journal

## 2025-01-25 - Hardcoded Credentials in Shell Scripts
**Vulnerability:** Found hardcoded Cloudflare API credentials (email and global API key) in `domaingratis`.
**Learning:** Shell scripts intended for quick setup or "one-off" tasks often contain hardcoded secrets for convenience, bypassing standard env var checks. This is common in "setup" scripts copied between VPS environments.
**Prevention:** Always use environment variable expansion `${VAR:-}` with a fallback to `read -s` for sensitive inputs. Never hardcode secrets, even in temporary scripts.
