FROM debian:jessie

ENV LANG=C DEBIAN_FRONTEND=noninteractive

# Setup DotDeb repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    curl https://www.dotdeb.org/dotdeb.gpg -o - | apt-key add - && \
    echo 'deb http://packages.dotdeb.org jessie all' > /etc/apt/sources.list.d/dotdeb.list

# Install mailcatcher
RUN apt-get update && \
    apt-get install -q -y libsqlite3-dev ruby ruby-dev build-essential && \
    gem install --no-ri --no-rdoc mailcatcher && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN groupadd --gid 900 devstack && useradd --uid 900 -g devstack --home /var/www --shell /usr/sbin/nologin devstack

VOLUME /var/www

EXPOSE 9000

# Install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends php5-fpm php5-curl php5-gd php5-mysqlnd php5-xdebug php5-intl

ADD conf /etc/php5/fpm

RUN echo 'date.timezone=UTC' >> /etc/php5/php.ini

CMD ["php5-fpm"]
