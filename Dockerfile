FROM soriyath/debian-nodejsmongodb:4
MAINTAINER Sumi Straessle

RUN DEBIAN_FRONTEND=noninteractive set -ex \
	&& apt-get update \
	&& apt-get -y install curl

RUN DEBIAN_FRONTEND=noninteractive set -ex \
	&& curl https://install.meteor.com/ | sh

# CLEANUP
RUN DEBIAN_FRONTEND=noninteractive apt-get clean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD mongodb.conf $ROOTFS/etc/mongodb.conf
WORKDIR /srv/www

EXPOSE 27017 28017 3000

CMD service mongodb start
