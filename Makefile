all: network pod nginx server

network:
	podman network create gitweb

pod: | network
	podman pod create --name gitweb \
		--publish 3000:3000 \
		--network git

nginx: | pod
	podman build -t gitweb-nginx -f Containerfile.nginx .
	podman create --name gitweb-nginx --pod git \
		git-nginx

server: | pod
	podman build -t gitweb-cgi -f Containerfile.cgi .
	podman create --name gitweb-cgi --pod git \
		-e GIT_SITE_NAME=test \
		-e GIT_DEFAULT_PROJECTS_ORDER=age \
		-v /srv/git:/srv/git:z \
		git-server

clean:
	-podman rm gitweb-cgi
	-podman rm gitweb-nginx
	-podman rmi gitweb-cgi
	-podman rmi gitweb-nginx
	-podman pod rm gitweb
	-podman network rm gitweb

.PHONY: pod nginx server clean
