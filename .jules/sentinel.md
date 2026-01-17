# Sentinel's Journal

## 2024-05-23 - Hardcoded Credentials in Shell Scripts
**Vulnerability:** Found hardcoded Cloudflare API credentials (`CF_ID` and `CF_KEY`) directly assigned in `domaingratis`.
**Learning:** Shell scripts copied from other sources or quick "hacks" often contain hardcoded secrets for convenience. The pattern of hardcoded credentials was also observed in `cf.sh` (though not fixed in this pass). Testing shell scripts requires extensive mocking of system binaries.
**Prevention:** Always check for env vars first (`${VAR:-}`) and fall back to `read -p` prompts. Never commit scripts with populated credential variables.
