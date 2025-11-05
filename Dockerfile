FROM alpine:3.18.2

ENV FTP_USER=foo \
    FTP_PASS=bar \
    GID=1000 \
    UID=1000 \
    ENABLE_FTPS=true \
    PASV_MIN_PORT=40000 \
    PASV_MAX_PORT=40009 \
    PASV_ADDRESS=0.0.0.0 \
    FTPS_CN=ftp.local

RUN apk add --no-cache --update \
    vsftpd==3.0.5-r2 \
    openssl \
    shadow

COPY ["/src/vsftpd.conf", "/etc"]
COPY ["/src/docker-entrypoint.sh", "/"]

EXPOSE 21/tcp 20/tcp 40000-40009/tcp
HEALTHCHECK CMD netstat -lnt | grep :21 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/vsftpd"]
