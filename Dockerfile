FROM alpine:3.10.3
MAINTAINER Tatsuya Fukata <tatsuya.fukata@gmail.com>

ENV URL https://github.com/h2o/h2o.git
ENV H2O_VERSION v2.2.6

RUN set -x \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && addgroup -g 1000 -S www-data \
    && adduser -u 1000 -D -S -G www-data www-data \
    && apk update \
    && apk upgrade \
    # need for ocsp stapling \
    && apk add -U perl openssl openssl-dev \
    # just needed since v2
    && apk add -U libstdc++ \
    # save state before installed packages for building \
    && grep ^P /lib/apk/db/installed | sed -e 's#^P:##g' | sort > /before \
    && apk add -U build-base \
                  ca-certificates \
                  cmake \
                  git \
                  linux-headers \
                  zlib-dev \
                  ruby \
                  ruby-dev \
                  bison \
                  wslay-dev \
                  wslay \
                  libuv-dev \
    && git clone $URL h2o \
    # build h2o \
    && cd h2o \
    && git checkout $H2O_VERSION \
    && cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on . \
    && make install \
    && cd .. \
    && rm -rf h2o \
    # remove packages installed just for building \
    && grep ^P /lib/apk/db/installed | sed -e 's#^P:##g' | sort > /after \
    # egrep -v '^g$' is hack. return code 123
    && diff /before /after | grep -e "^+[^+]" | sed -e 's#+##g' | egrep -v '^g$' | xargs -n1 apk del \
    && rm /before /after \
    && rm -rf /var/cache/apk/* \
		&& mkdir /etc/h2o \
    # just test it \
    && h2o -v \
    # install php \
    && apk add -U libzip libwebp \
                  php7 \
                  php7-common \
                  php7-memcached \
                  php7-redis \
                  php7-mysqlnd \
                  php7-dom \
                  php7-ctype \
                  php7-curl \
                  php7-cgi \
                  php7-gd \
                  php7-intl \
                  php7-json \
                  php7-mbstring \
                  php7-mcrypt \
                  php7-mysqli \
                  php7-opcache \
                  php7-pdo \
                  php7-pdo_mysql \
                  php7-pdo_pgsql \
                  php7-posix \
                  php7-session \
                  php7-xml \
                  php7-iconv \
                  php7-phar \
                  php7-openssl \
                  php7-zip \
                  php7-fileinfo \
                  php7-tokenizer \
                  php7-xmlwriter \
                  git \
                  composer \
    && php -v

ADD examples/h2o/h2o.conf /etc/h2o/
ADD examples/www /var/www/
WORKDIR /etc/h2o

EXPOSE 80 443
CMD ["h2o", "-m", "master", "-c", "h2o.conf"]
