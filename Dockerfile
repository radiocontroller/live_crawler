FROM ruby:2.6.1
ENV GEM_HOME="/usr/local/bundle" PATH="$GEM_HOME/bin:$PATH"
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev && apt-get install -y cron vim
RUN mkdir /live_crawler
WORKDIR /live_crawler
COPY Gemfile /live_crawler/Gemfile
COPY Gemfile.lock /live_crawler/Gemfile.lock
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
    && gem install bundler \
    && bundle install
COPY . /live_crawler
RUN bundle exec whenever --update-crontab -s 'environment=production'
