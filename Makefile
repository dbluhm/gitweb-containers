all: network pod nginx server

network:
	podman network create gitweb

pod: | network
	podman pod create --name gitweb \
		--publish 3000:3000 \
		--network gitweb

nginx: | pod
	podman build -t gitweb-nginx -f Containerfile.nginx .
	podman create --name gitweb-nginx --pod gitweb \
		gitweb-nginx

server: | pod
	podman build -t gitweb-cgi -f Containerfile.cgi .
	podman create --name gitweb-cgi --pod gitweb \
		-e GIT_SITE_NAME=test \
		-e GIT_DEFAULT_PROJECTS_ORDER=age \
		-v /tmp/git:/srv/git:z \
		gitweb-cgi

clean:
	-podman rm gitweb-cgi
	-podman rm gitweb-nginx
	-podman rmi gitweb-cgi
	-podman rmi gitweb-nginx
	-podman pod rm gitweb
	-podman network rm gitweb

.PHONY: pod nginx server clean
