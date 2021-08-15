FROM ruby:2.7.4

RUN apt-get update -qq && apt-get install -y build-essential tzdata libpq-dev \
  postgresql-client && rm -rf /var/lib/apt/lists/*

COPY . /usr/src/app
WORKDIR /usr/src/app
