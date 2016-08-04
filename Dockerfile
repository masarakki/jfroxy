FROM ruby:2.3.1

WORKDIR /opt
ADD Gemfile /opt/Gemfile
ADD Gemfile.lock /opt/Gemfile.lock

RUN bundle install --path vendor/bundle --deployment --without development test

ADD config.ru /opt/config.ru
ADD lib /opt/lib

EXPOSE 9292

CMD rackup -o 0.0.0.0 -E production
