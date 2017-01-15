FROM soriyath/debian-nodejs:4
MAINTAINER Sumi Straessle

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 1.4.2_3

RUN set -ex \
	&& apt-get update \
	&& apt-get -y install curl

# Switch to shell-less non-root user
RUN mkdir -p /usr/local/src/meteor \
	&& useradd --home=/usr/local/src/meteor --shell=/bin/bash meteor \
	&& usermod -L meteor \
	&& usermod -a -G www-data meteor \
	&& chown meteor:www-data /usr/local/src/meteor
USER meteor

ENV HOME /usr/local/src/meteor

RUN set -ex \
	&& curl https://install.meteor.com/ | sh
USER root
RUN update-alternatives --install /usr/bin/meteor meteor "/usr/local/src/meteor/.meteor/packages/meteor-tool/${VERSION}/mt-os.linux.x86_64/scripts/admin/launch-meteor" 1

# ACL are not supported by AUFS which is standard Docker filesystem
RUN chown root:www-data /var/log/supervisor \
	&& chmod 774 /var/log/supervisor

RUN apt-get upgrade -y

RUN apt-get clean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /srv/app \
	&& chown meteor:www-data /srv/app
USER meteor
WORKDIR /srv/app

EXPOSE 3000

# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
