# Sentinel Journal

## 2024-10-24 - Hardcoded Secrets in Utility Scripts
**Vulnerability:** Found hardcoded Cloudflare API credentials (`CF_ID` and `CF_KEY`) in multiple scripts (`domaingratis`, `cf.sh`).
**Learning:** These scripts were likely intended for personal use or a specific setup but were shared/committed without stripping secrets. The ease of "just works" functionality often leads to hardcoded secrets.
**Prevention:**
1. Always assume scripts will be public.
2. Use environment variables as primary configuration.
3. Fallback to interactive prompts (using `read -s` for secrets) if env vars are missing.
4. Add pre-commit hooks or CI scans to detect potential secrets (high entropy strings or known keys).

## 2024-10-24 - Testing Interactive Bash Scripts
**Vulnerability:** Difficulty in testing interactive scripts (`read -p`) automatedly can lead to skipped tests and regressions.
**Learning:** We can robustly test interactive scripts by:
1. Mocking the environment (functions for `curl`, `wget`, `apt`).
2. Piping input to the script `echo "input" | ./script`.
3. Using environment variables to bypass prompts during testing if the script supports it.
**Prevention:** Design scripts to accept arguments or environment variables first, only dropping to interactive mode if those are missing. This makes them inherently testable and automation-friendly.
