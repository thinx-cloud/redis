#!/bin/sh
# POSIX sh, not bash — the Alpine-based image has no /bin/bash. Run from cron
# (see bgsave-cron), so a bad shebang would fail silently every 15 minutes.

redis-cli -a ${REDIS_PASSWORD} SAVE
