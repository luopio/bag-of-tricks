#################################################################
#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
#################################################################

# Based loosely on peenuty/rails-passenger-nginx
# Open it up: sudo docker run -t -i -p 80:80 bash -l

FROM ubuntu:14.04
MAINTAINER Lauri Kainulainen <lauri.kainulainen@gmail.com>

# reduce output from debconf
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/nginx/sbin

# Setup all needed dependencies
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install curl libcurl4-gnutls-dev git libxslt-dev libxml2-dev libpq-dev libffi-dev imagemagick

# Niceties
RUN apt-get -y install vim # wajig

# Install rvm, ruby, rails, rubygems, passenger, nginx (installed by passenger under /opt)
# Checked on 23.5
ENV RUBY_VERSION 2.1.2
ENV RAILS_VERSION 4.1.0
ENV PASSENGER_VERSION 4.0.41

# All rvm commands need to be run as bash -l or they won't work.
RUN \curl -sSL https://get.rvm.io | bash -s stable --rails
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc
RUN /bin/bash -l -c 'rvm requirements'
RUN /bin/bash -l -c 'rvm install $RUBY_VERSION && rvm use $RUBY_VERSION --default'
RUN /bin/bash -l -c 'rvm rubygems current'
RUN /bin/bash -l -c 'gem install passenger --version $PASSENGER_VERSION'
RUN /bin/bash -l -c 'passenger-install-nginx-module --auto-download --auto --prefix=/opt/nginx'
RUN /bin/bash -l -c 'gem install bundler'
RUN /bin/bash -l -c 'gem install rails --version=$RAILS_VERSION'

# You need a javascript runtime to run rails
RUN apt-get -y install nodejs
RUN mkdir -p /var/log/nginx/

ADD docker/rails-nginx-passenger/nginx.conf /opt/nginx/conf/nginx.conf

# Add the application itself
ADD . /srv/cyclone
WORKDIR /srv/cyclone
RUN /bin/bash -l -c 'bundle install --deployment'

VOLUME ["/srv", "/opt/nginx/"]

# Exposing port 80 for nginx 
EXPOSE 80
# EXPOSE 443

# Startup commands
CMD /opt/nginx/sbin/nginx
# ENTRYPOINT ["/opt/nginx/sbin/nginx"]

