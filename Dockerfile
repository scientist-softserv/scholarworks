FROM phusion/passenger-ruby26 as hyrax-base

RUN echo 'Downloading Packages' && \
    # curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update -qq && \
    apt-get install -y \
      build-essential \
      ffmpeg \
      imagemagick \
      libpq-dev \
      libsasl2-dev \
      libsndfile1-dev \
      libvips \
      nodejs \
      openjdk-8-jdk \
      postgresql-client \
      pv \
      tzdata \
      unzip \
      zip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    echo 'Packages Downloaded'


RUN rm /etc/nginx/sites-enabled/default

ENV APP_HOME /home/app/webapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=4

ADD Gemfile* $APP_HOME/
RUN gem install bundler
RUN bundle check || bundle install

# RUN touch /var/log/worker.log && chmod 666 /var/log/worker.log
# RUN mkdir /etc/service/worker
# ADD ops/worker.sh /etc/service/worker/run
# RUN chmod +x /etc/service/worker/run

RUN mkdir /usr/local/fits
RUN curl -L https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip > fits.zip
RUN unzip fits.zip -d /usr/local/fits

# ADD ops/image-magick/policy.xml /etc/ImageMagick-6/policy.xml

RUN mkdir -p /data/tmp

ADD . $APP_HOME
RUN chown -R app $APP_HOME

# this is so that these items are cached and only have to be updated
RUN  /sbin/setuser app /bin/bash -l -c 'cd /home/app/webapp && DB_ADAPTER=nulldb bundle exec rake assets:precompile'
# Asset complie and migrate if prod, otherwise just start nginx
# ADD ops/nginx.sh /etc/service/nginx/run
# RUN chmod +x /etc/service/nginx/run
# RUN rm -f /etc/service/nginx/down

FROM hyrax-base as hyrax-worker
ENV MALLOC_ARENA_MAX=2
CMD ./bin/worker