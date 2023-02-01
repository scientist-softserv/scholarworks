FROM ghcr.io/scientist-softserv/dev-ops/samvera:f71b284f as hyrax-base

COPY --chown=1001:101 $APP_PATH/Gemfile* /app/samvera/hyrax-webapp/
RUN bundle install --jobs "$(nproc)"
COPY --chown=1001:101 $APP_PATH/bin/db-migrate-seed.sh /app/samvera/

COPY --chown=1001:101 $APP_PATH /app/samvera/hyrax-webapp

RUN RAILS_ENV=production SECRET_KEY_BASE=FAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKE DB_ADAPTER=nulldb DB_URL='postgresql://fake' bundle exec rake assets:precompile

FROM hyrax-base as hyrax-worker
ENV MALLOC_ARENA_MAX=2
CMD ./bin/worker
