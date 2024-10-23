FROM redis:6.2-alpine

LABEL name="thinxcloud/redis" version="1.5.101"

ARG REDIS_PASSWORD
ENV REDIS_PASSWORD=${REDIS_PASSWORD}

ARG ALLOW_EMPTY_PASSWORD=no
ENV ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}

ARG REDIS_DISABLE_COMMANDS=FLUSHALL
ENV REDIS_DISABLE_COMMANDS=${REDIS_DISABLE_COMMANDS}

RUN apk update \
  && apk add ca-certificates apt-transport-https cron

# adduser --system --disabled-password --shell /bin/bash redis

COPY ./bgsave-cron /bgsave-cron
COPY ./redis_bgsave.sh /redis_bgsave.sh
RUN crontab /bgsave-cron

EXPOSE 6379

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
