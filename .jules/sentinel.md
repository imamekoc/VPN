## 2024-05-23 - Hardcoded Secrets in VPS Scripts
**Vulnerability:** Found a Telegram Bot Token (`6226368145:...`) hardcoded in multiple files (`Finaleuy/botssh.sh`, `Finaleuy/bot.sh`, etc).
**Learning:** Secrets were copy-pasted across multiple scripts. Fixing one file (`botssh.sh`) was insufficient; searching the codebase for the *value* of the secret was necessary to find all occurrences.
**Prevention:** Use `grep -r "SECRET_VALUE"` (if known) or `grep -r "KEY"` during audits. Use environment variables (e.g., `TELEGRAM_BOT_TOKEN`) for all credentials.
