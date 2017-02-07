FROM alpine:latest
#ARG user=1000
#ARG username=dockeruser
#RUN adduser -u $user -D $username
RUN apk update --no-cache && \
    apk add make gcc vim musl-dev gzip --no-cache
VOLUME ["/data"]
#USER $user
WORKDIR /build

