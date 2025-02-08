# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.1.2
ARG BUNDLE_WITHOUT="${BUNDLE_WITHOUT:-development:test}"

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /coin_guru_api

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    # Add PostgreSQL development libraries
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Update RubyGems and Bundler
RUN gem update --system 3.3.22 && \
    gem install bundler -v 2.6.3

# Configure environment
ENV RAILS_ENV="${RAILS_ENV:-production}" \
    BUNDLE_DEPLOYMENT="${BUNDLE_DEPLOYMENT:-0}" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="${BUNDLE_WITHOUT}" \
    LANG=C.UTF-8 \
    PATH="/coin_guru_api/bin:$PATH"

# Development stage
FROM base AS development

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with permissions
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid rails --create-home --shell /bin/bash rails && \
    mkdir -p /coin_guru_api/bin && \
    chown -R rails:rails /coin_guru_api

USER rails:rails

COPY --chown=rails:rails Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3

# Generate binstubs directly for Rails
RUN set -ex; \
    mkdir -p bin; \
    rm -f bin/rails; \
    bundle binstubs railties --force; \
    chmod +x bin/*; \
    { echo "Generated binstubs:"; ls -l bin/; }

COPY --chown=rails:rails . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["rails", "server", "-b", "0.0.0.0"]