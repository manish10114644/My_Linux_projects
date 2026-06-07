# Automated Linux System Health Monitor & Alerting Engine

A production-ready Bash utility designed to capture live server resource metrics, log historical trends, automate executions via Cron, manage storage via logrotate, and fire external real-time alerts via Discord/Slack Webhooks.

## Features
* **Dynamic Metric Extraction:** Parses raw kernel data to extract precise Disk (`df`) and Memory (`free`) utilization percentages.
* **Persistent I/O Logging:** Appends systematic readouts to `/var/log/system_monitor.log`.
* **Automated Background Cycles:** Integrates with the `cron` daemon to execute autonomously every 5 minutes.
* **Automated Log Rotation:** Employs `logrotate` policies with `gzip` compression and rolling retention limits to protect root partitions from storage exhaustion.
* **Closed-Loop PUSH Alerting:** Dispatches real-time structured JSON payloads over `curl` to external communication webhooks when user-defined thresholds are breached.

##  Infrastructure Architecture
1. **Script Logic:** `System_Health_Template.sh` (Core Bash Script)
2. **Automation Layer:** Root Crontab entry (`*/5 * * * *`)
3. **Storage Security:** Logrotate configuration script at `/etc/logrotate.d/system_monitor`
4. **Notification Layer:** Discord Channel Webhook Integration

##  Installation & Setup
1. Clone the repository and configure execution privileges:
   ```bash
   chmod u+x System_Health_Template.sh
