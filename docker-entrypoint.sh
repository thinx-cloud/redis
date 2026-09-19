#!/bin/sh
# POSIX sh, not bash: the image is Alpine-based and the Dockerfile installs
# only ca-certificates and apk-cron, so /bin/bash does not exist. With a bash
# shebang the kernel cannot load the interpreter and reports
# "exec /docker-entrypoint.sh: no such file or directory" — redis then never
# starts. Nothing below uses bash-specific syntax.

set -e

redis-server --port 6379 --requirepass ${REDIS_PASSWORD}

# no need anymore, will be trigered by app:
redis-cli -a ${REDIS_PASSWORD} BGSAVE
