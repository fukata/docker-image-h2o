FROM debian:jessie
MAINTAINER fukata <tatsuya.fukata@gmail.com>

ENV H2O_VERSION  tags/v2.1.0-beta4

RUN set -x \
    && echo "deb http://httpredir.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && apt-get install locate git cmake build-essential checkinstall autoconf pkg-config libtool python-sphinx wget libcunit1-dev nettle-dev libyaml-dev libssl-dev ruby ruby-dev bison -y --fix-missing \
    && apt-get -t jessie-backports install libuv1-dev -y --fix-missing \
    && git clone https://github.com/tatsuhiro-t/wslay.git \
    && git clone https://github.com/h2o/h2o.git \
    && cd /wslay && autoreconf -i && automake && autoconf && ./configure && make && make install \
    && cd /h2o && git checkout $H2O_VERSION && cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on . && make && make install

VOLUME /var/log /etc/letsencrypt /var/www /etc/h2o

WORKDIR /etc/h2o

EXPOSE 80 443
CMD h2o -m master -c h2o.conf
