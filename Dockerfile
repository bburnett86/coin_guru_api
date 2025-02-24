# syntax=docker/dockerfile:1

# Stage 1: Base image with essential dependencies
ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-alpine AS base

WORKDIR /coin_guru_api

# Install essential runtime dependencies (Alpine packages)
RUN apk add --no-cache \
    build-base \
    postgresql-client \
    postgresql-dev \
    vips-dev \
    jemalloc \
    tzdata \
    curl \
    bash

# Configure Ruby and Bundler
RUN gem update --system 3.3.22 \
    && gem install bundler -v 2.6.3

ENV RAILS_ENV="${RAILS_ENV:-production}" \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="${BUNDLE_WITHOUT:-development:test}" \
    LD_PRELOAD="/usr/lib/libjemalloc.so.2" \
    RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.5 \
    RUBY_GC_MALLOC_LIMIT=100000000 \
    RUBY_GC_OLDMALLOC_LIMIT=20000000 \
    MALLOC_ARENA_MAX=2

# Copy only dependency files first for caching optimization
COPY Gemfile Gemfile.lock ./

# Install gems efficiently
RUN bundle install --jobs=4 --retry=3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy the entire application code
COPY . .

# Stage 2: Development environment
FROM base AS development

# Install development tools
RUN apk add --no-cache \
    git \
    nodejs \
    yarn \
    chromium \
    chromium-chromedriver

# Create a non-root user
RUN addgroup -S rails && adduser -S rails -G rails \
    && chown -R rails:rails /coin_guru_api

USER rails

# Generate binstubs
RUN bundle binstubs railties --force

# Stage 3: Test environment
FROM base AS test

ENV RAILS_ENV=test \
    BUNDLE_WITHOUT=""

# Install test-specific dependencies
RUN apk add --no-cache \
    postgresql-client \
    chromium \
    chromium-chromedriver

# Stage 4: Production environment
FROM base AS production

# Set up a non-root user for security
RUN addgroup -S rails && adduser -S rails -G rails \
    && chown -R rails:rails /coin_guru_api

USER rails

# Ensure logs and tmp directories exist
RUN mkdir -p tmp/cache log \
    && touch log/production.log

# Precompile assets and cleanup
RUN bundle exec rails assets:precompile \
    && rm -rf tmp/cache log/*.log

# Entrypoint setup
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["exec", "rails", "server", "-b", "0.0.0.0"]
