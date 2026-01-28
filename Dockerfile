ARG RUBY_VERSION
FROM docker.io/library/ruby:${RUBY_VERSION}-slim

RUN apt update && \
    apt install -y build-essential && \
    apt autoremove -y && apt clean

WORKDIR /opt

ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/opt/vendor/bundle" \
    BUNDLE_WITHOUT="development test"

ADD Gemfile /opt/Gemfile
ADD Gemfile.lock /opt/Gemfile.lock

RUN bundle install

ADD config.ru /opt/config.ru
ADD lib /opt/lib

EXPOSE 80

CMD bundle exec rackup -o 0.0.0.0 -E production -p 80
