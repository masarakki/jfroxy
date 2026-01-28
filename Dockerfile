ARG RUBY_VERSION
FROM docker.io/library/ruby:${RUBY_VERSION}-slim

RUN apt update && \
    apt install -y build-essential && \
    apt autoremove -y && apt clean

WORKDIR /opt
ADD Gemfile /opt/Gemfile
ADD Gemfile.lock /opt/Gemfile.lock

RUN bundle install --path vendor/bundle --deployment --without development test

ADD config.ru /opt/config.ru
ADD lib /opt/lib

EXPOSE 80

CMD bundle exec rackup -o 0.0.0.0 -E production -p 80
