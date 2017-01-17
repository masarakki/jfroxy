FROM ruby:2.3.3

WORKDIR /opt
ADD Gemfile /opt/Gemfile
ADD Gemfile.lock /opt/Gemfile.lock

RUN bundle install --path vendor/bundle --deployment --without development test

ADD config.ru /opt/config.ru
ADD lib /opt/lib

EXPOSE 80

CMD rackup -o 0.0.0.0 -E production -p 80
