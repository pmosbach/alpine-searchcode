FROM alpine:edge

RUN apk add bash bind-tools build-base coreutils curl git linux-headers ncurses nginx pcre-dev python3 python3-dev --update-cache && \
    apk add aha --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    pip3 install --upgrade pip && \
    pip3 install uwsgi && \
    pip3 install flask && \
    apk del build-base linux-headers pcre-dev python3-dev && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/
RUN git clone --depth 1 https://github.com/TKCERT/testssl.sh-webfrontend.git && \
    chown -R nginx:nginx testssl.sh-webfrontend && \
    chmod 777 /run/ -R && \
    chmod 777 /root/ -R
WORKDIR /usr/src/testssl.sh-webfrontend
RUN git clone --depth 1 https://github.com/drwetter/testssl.sh.git && \
    sed -i -e "s/checkTimeout = 90/checkTimeout = 300/g" SSLTestPortal.py

# EXPOSE HTTP port
EXPOSE 80

# COPY entrypoint script and config files
COPY entrypoint.sh /entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY uwsgi.ini /uwsgi.ini

#ENTRYPOINT ["python3","SSLTestPortal.py"]
CMD ["/bin/sh", "/entrypoint.sh"]