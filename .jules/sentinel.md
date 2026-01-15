## 2024-05-23 - Hardcoded Secrets in VPS Scripts
**Vulnerability:** Found hardcoded Cloudflare API keys and emails in `cf.sh` and `domaingratis` scripts.
**Learning:** Shell scripts are often overlooked in security scans compared to application code. Hardcoded credentials in these scripts can grant full DNS control.
**Prevention:** Use environment variables for sensitive data. Implement interactive prompts (`read -s`) as fallback for manual execution. Added regression test `tests/test_cf_secrets.sh` to prevent re-introduction.
