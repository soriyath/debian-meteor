FROM soriyath/debian-nodejsmongodb:4
MAINTAINER Sumi Straessle

ENV DEBIAN_FRONTEND noninteractive

RUN set -ex \
	&& apt-get update \
	&& apt-get -y install curl

# Switch to shell-less non-root user
RUN useradd --home=/home/meteor --shell=/bin/bash meteor \
	&& usermod -L meteor \
	&& usermod -a -G www-data meteor
USER meteor

RUN set -ex \
	&& curl https://install.meteor.com/ | sh

# CLEANUP
RUN apt-get clean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD mongodb.conf $ROOTFS/etc/mongodb.conf
WORKDIR /srv/www

EXPOSE 27017 28017 3000

# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
