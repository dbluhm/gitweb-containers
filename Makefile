all: network pod nginx server

network:
	podman network create git

pod: | network
	podman pod create --name git \
		--publish 3000:3000 \
		--network git

nginx: | pod
	podman build -t git-nginx -f Containerfile .
	podman create --name git-nginx --pod git \
		git-nginx

server: | pod
	podman build -t git-server -f Containerfile.git .
	podman create --name git-server --pod git \
		-e GIT_PROJECT_ROOT=/srv/git \
		-e GIT_SITE_NAME=test \
		-e GIT_DEFAULT_PROJECTS_ORDER=age \
		-v /srv/git:/srv/git:z \
		-v /srv/git-server/gitweb.conf:/etc/gitweb.conf:z \
		git-server

clean:
	-podman rm git-nginx
	-podman rm git-server
	-podman rmi git-server
	-podman pod rm git
	-podman network rm git

.PHONY: pod nginx server clean
