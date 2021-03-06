FROM openjdk:8-jre-alpine

RUN apk add wget ca-certificates openssl-dev --update-cache && \
    wget -O /tmp/searchcode-server-community.tar.gz https://searchcode.com/static/searchcode-server-community.tar.gz && \
    cd /tmp && \
    tar -xvzf searchcode-server-community.tar.gz && \
    mkdir -p /usr/src && \
    mv searchcode-server-community/release /usr/src/searchcode && \
    ls -al /usr/src/searchcode && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/searchcode

EXPOSE 8080/tcp

CMD ["/bin/sh", "searchcode-server.sh"]