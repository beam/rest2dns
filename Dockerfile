FROM ruby:2.6.1-alpine
MAINTAINER info@kraxnet.cz

RUN apk add knot knot-utils git build-base bash

WORKDIR /usr/app

COPY Gemfile.docker /usr/app/Gemfile

RUN gem install bundler
RUN bundle config --global github.https true
RUN bundle config --global silence_root_warning 1
RUN bundle install

RUN mkdir /run/knot /etc/knot/zones
RUN chown -R knot:knot /run/knot /etc/knot

COPY config.ru /usr/app/

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
