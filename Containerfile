FROM nginx:mainline-alpine
EXPOSE 3000/tcp
RUN apk add --update --no-cache \
        git-gitweb

COPY ./git.conf.template /etc/nginx/templates/default.conf.template
