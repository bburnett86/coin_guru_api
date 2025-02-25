# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.3.0 
ARG BUNDLE_WITHOUT="${BUNDLE_WITHOUT:-development:test}"

# Base stage (common for all environments)
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /coin_guru_api

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    gnupg \
    libjemalloc2 \
    libvips \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Add PostgreSQL repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(grep -oP 'VERSION_CODENAME=\K\w+' /etc/os-release)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

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

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./

# Install build tools temporarily for gem installation
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    gcc \
    make \
    && bundle install --jobs=4 --retry=3 \
    && apt-get remove -y build-essential gcc make \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Copy application code
COPY . .

# Development stage
FROM base AS development

# Install additional development dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with permissions and change ownership of directories
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid rails --create-home --shell /bin/bash rails && \
    mkdir -p /coin_guru_api/bin && \
    chown -R rails:rails /coin_guru_api && \
    mkdir -p /usr/local/bundle && \
    chown -R rails:rails /usr/local/bundle

USER rails:rails

# Generate binstubs for Rails
RUN set -ex; \
    mkdir -p bin; \
    rm -f bin/rails; \
    bundle binstubs railties --force; \
    chmod +x bin/*; \
    { echo "Generated binstubs:"; ls -l bin/; }

# Precompile Bootsnap cache
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Set entrypoint and command
ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["rails", "server", "-b", "0.0.0.0"]

# Test stage
FROM base AS test

# Install test dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Set Rails environment to test
ENV RAILS_ENV=test

# Run tests
CMD ["rails", "test"]

# Production stage
FROM base AS production

# Set Rails environment to production
ENV RAILS_ENV=production

# Precompile assets
RUN bundle exec rails assets:precompile

# Set entrypoint and command
ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["rails", "server", "-b", "0.
