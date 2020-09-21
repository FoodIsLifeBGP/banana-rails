FROM rubylang/ruby:2.6.6-bionic
RUN apt-get update -qq && apt-get -y install postgresql-client libpq5 libpq-dev
RUN mkdir /banana-rails
WORKDIR /banana-rails

# gem install
COPY Gemfile /banana-rails/Gemfile
COPY Gemfile.lock /banana-rails/Gemfile.lock
RUN gem install bundler:2.1.4
RUN bundle install
RUN gem install pg -v '1.1.4' --source 'https://rubygems.org/'

COPY . /banana-rails

