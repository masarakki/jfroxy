FROM ruby:2.6-alpine

WORKDIR /opt
ADD Gemfile /opt/Gemfile
ADD Gemfile.lock /opt/Gemfile.lock

RUN apk add --no-cache --update alpine-sdk &&\
    gem update --system &&\
    gem install bundler &&\
    bundle install --path vendor/bundle --deployment --without development test &&\
    apk del alpine-sdk

ADD config.ru /opt/config.ru
ADD lib /opt/lib

EXPOSE 80

CMD bundle exec rackup -o 0.0.0.0 -E production -p 80
