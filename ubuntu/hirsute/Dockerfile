FROM ubuntu:hirsute

MAINTAINER vicamo@gmail.com

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		binfmt-support \
		qemu-user-static \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*_dists_*

ENTRYPOINT ["sh", "-c", "update-binfmts --enable && dpkg-reconfigure qemu-user-static"]
