<<<<<<< Updated upstream
FROM registry.gitlab.com/notch8/cal-state-hyrax/base:latest

ADD http://timejson.herokuapp.com build-time
#ADD ops/webapp.conf /etc/nginx/sites-enabled/webapp.conf
#ADD ops/env.conf /etc/nginx/main.d/env.conf
ADD . $APP_HOME

RUN cd /home/app/webapp && \
    (/sbin/setuser app bundle check || /sbin/setuser app bundle install) && \
    /sbin/setuser app bundle exec rake assets:precompile DB_ADAPTER=nulldb && \
    chown -R app $APP_HOME && \
    rm -f /etc/service/nginx/down

CMD ["/sbin/my_init"]

=======
FROM ghcr.io/scientist-softserv/dev-ops/samvera:f71b284f as hyrax-base

COPY --chown=1001:101 $APP_PATH/Gemfile* /app/samvera/hyrax-webapp/
RUN bundle install --jobs "$(nproc)"
COPY --chown=1001:101 $APP_PATH/bin/db-migrate-seed.sh /app/samvera/

COPY --chown=1001:101 $APP_PATH /app/samvera/hyrax-webapp

RUN RAILS_ENV=production SECRET_KEY_BASE=FAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKE DB_ADAPTER=nulldb DB_URL='postgresql://fake' bundle exec rake assets:precompile

FROM hyrax-base as hyrax-worker
ENV MALLOC_ARENA_MAX=2
CMD ./bin/worker
>>>>>>> Stashed changes
