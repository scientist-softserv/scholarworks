if Rails.env.production?
  config = YAML.load(ERB.new(IO.read(Rails.root + 'config' + 'redis.yml')).result)[Rails.env].with_indifferent_access

<<<<<<< Updated upstream
  redis_conn = { url: "redis://#{config[:host]}:#{config[:port]}/" }

  Sidekiq.configure_server do |s|
    s.redis = redis_conn
  end

  Sidekiq.configure_client do |s|
    s.redis = redis_conn
  end
=======
Sidekiq.configure_server do |s|
  s.redis = redis_config
<<<<<<< Updated upstream
=======
end

Sidekiq.configure_client do |s|
  s.redis = redis_config
>>>>>>> Stashed changes
>>>>>>> Stashed changes
end
