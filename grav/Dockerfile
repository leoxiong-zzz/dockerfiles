# Grav CMS - https://github.com/getgrav/grav
# 
# To build: docker build -t leoxiong/grav .
# To run: docker run --name grav -v $HOME/grav/user/:/home/grav/www/user_mount/ -v $HOME/grav/logs:/home/grav/www/logs -p 127.0.0.1:8080:80 -it leoxiong/grav

FROM debian:jessie
MAINTAINER Leo Xiong <hello@leoxiong.com>

# install system dependencies
RUN apt-get update && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        nginx \
        php5-curl \
        php5-fpm \
        php5-gd 

# copy nginx config over
COPY grav.www /etc/nginx/sites-available/grav.www
RUN rm /etc/nginx/sites-enabled/default \
	&& ln -s /etc/nginx/sites-available/grav.www /etc/nginx/sites-enabled/grav.www \
        && service nginx restart

# create grav user
RUN useradd --create-home grav

# clone and install grav
USER grav
RUN mkdir /home/grav/www
WORKDIR /home/grav/www
RUN git clone https://github.com/getgrav/grav.git .
RUN curl -sS https://getcomposer.org/installer | php \
        && bin/composer.phar install --no-dev --optimize-autoloader \
        && bin/grav install

# install plugins
RUN bin/gpm install admin \
        featherlight \
        highlight \
        simplesearch \
        sitemap \
        taxonomylist

# set permissions
USER root
RUN chown -R grav:www-data . \
        && find . -type f -exec chmod u=rw,g=r,o= {} \; \
        &&  find . -type d -exec chmod u=rw,g=rxs,o= {} \; \
        && chmod -R g+w assets/ backup/ cache/ images/ logs/ user/

COPY runtime.sh /home/grav/runtime.sh
ENTRYPOINT sh /home/grav/runtime.sh
CMD tail -f /var/log/nginx/access.log
