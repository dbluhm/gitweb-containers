FROM docker.io/spaletta/fcgiwrap-perl
RUN apk add --update --no-cache \
        git-daemon git-gitweb
COPY gitweb.conf /etc/.
