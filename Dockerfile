FROM ruby:2.4.2-alpine3.6

ENV APP_ROOT /usr/src/app

WORKDIR $APP_ROOT

RUN apk update \
  && apk upgrade \
  && apk add --update \
    build-base \
    libc6-compat \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    sqlite-dev \
    tzdata \
    openssl \
  && rm -rf /var/cache/apk/*

COPY Gemfile ${APP_ROOT}/Gemfile
COPY Gemfile.lock ${APP_ROOT}/Gemfile.lock

RUN echo 'gem: --no-document' >> ~/.gemrc \
  && cp ~/.gemrc /etc/gemrc \
  && chmod uog+r /etc/gemrc \
  && bundle config --global build.nokogiri --use-system-libraries jobs 4 \
  && bundle install \
  && rm -rf ~/.gem

COPY . $APP_ROOT

EXPOSE 3333
