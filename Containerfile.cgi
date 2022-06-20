FROM alpine:latest
RUN apk add --update --no-cache \
        perl perl-cgi fcgiwrap git-daemon git-gitweb

COPY gitweb.conf /etc/.
ENTRYPOINT [ "fcgiwrap", "-s", "tcp:0.0.0.0:9000", "-f" ]
EXPOSE 9000
