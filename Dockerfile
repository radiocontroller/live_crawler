FROM ruby:2.2.3
ENV GEM_HOME="/usr/local/bundle" PATH="$GEM_HOME/bin:$PATH"
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev && apt-get install -y cron vim
RUN mkdir /crawler_with_sinatra
WORKDIR /crawler_with_sinatra
COPY Gemfile /crawler_with_sinatra/Gemfile
COPY Gemfile.lock /crawler_with_sinatra/Gemfile.lock
RUN gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    && gem install bundler \
    && bundle install
COPY . /crawler_with_sinatra
RUN bundle exec whenever --update-crontab -s 'environment=production'
