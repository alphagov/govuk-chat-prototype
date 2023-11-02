ARG ruby_version=3.2.2
ARG base_image=ghcr.io/alphagov/govuk-ruby-base:$ruby_version
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:$ruby_version


FROM $builder_image AS builder

WORKDIR $APP_HOME
COPY Gemfile* .ruby-version ./
RUN bundle install
COPY . .
RUN bootsnap precompile --gemfile .

# TODO switch to SECRET_KEY_BASE_DUMMY=1 once we've upgraded to rails 7.1
# https://github.com/rails/rails/pull/46760
RUN SECRET_KEY_BASE="ignore" rails assets:precompile && rm -fr log

FROM $base_image

ENV GOVUK_APP_NAME=govuk-chat
ENV PIDFILE=/tmp/server.pid

WORKDIR $APP_HOME
COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=builder $BOOTSNAP_CACHE_DIR $BOOTSNAP_CACHE_DIR
COPY --from=builder $APP_HOME .

USER app
CMD ["puma"]
