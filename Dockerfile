FROM redis:8.6.3-alpine3.23

LABEL name="thinxcloud/redis" version="1.5.101"

# REDIS_PASSWORD is deliberately not declared here. This is a single-stage
# build, so an ENV would be baked into the published (public) thinxcloud/redis
# image. docker-entrypoint.sh reads it from the container environment at start
# time, supplied by docker-compose `environment:`.

ARG ALLOW_EMPTY_PASSWORD=no
ENV ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}

ARG REDIS_DISABLE_COMMANDS=FLUSHALL
ENV REDIS_DISABLE_COMMANDS=${REDIS_DISABLE_COMMANDS}

RUN apk update \
    && apk add ca-certificates apk-cron

# adduser --system --disabled-password --shell /bin/bash redis

# this bgsave script will be called by cron to trigger a bgsave once a while,
# which will create a dump.rdb file in the /data directory, which is mounted 
# as a volume in the docker-compose.yml file. This way we can have a backup
# of the redis data in case of a crash or if we need to restore it later. 
# downside is that this approach does not allow us to use a distroless redis
# image so far (we need to have cron and bash available), but it is a simple and
# effective solution for now. we can always switch to a distroless image later # # if we find a way to run cron and bash in it (e.g. using API).

COPY ./bgsave-cron /bgsave-cron
COPY ./redis_bgsave.sh /redis_bgsave.sh
RUN crontab /bgsave-cron

EXPOSE 6379

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
