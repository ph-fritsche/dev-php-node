FROM php:7-cli

RUN apt-get update \
 && export DEBIAN_FRONTEND=noninteractive

# tools
RUN apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
 && apt-get -y install git openssh-client less iproute2 procps iproute2 lsb-release

# unzip
RUN apt-get -y install unzip

# xdebug
RUN yes | pecl -v install xdebug \
 && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
 && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini

# composer
ADD getcomposer.sh getcomposer.sh
RUN chmod 1 getcomposer.sh \
 && ./getcomposer.sh \
 && mv composer.phar /usr/local/bin/composer \
 && rm getcomposer.sh

# node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
 && apt-get -y install nodejs \
 && npm install -g yarn

# clean up
RUN apt-get -y autoremove \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/bash" ]
