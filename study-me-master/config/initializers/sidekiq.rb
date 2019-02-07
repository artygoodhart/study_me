Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

if Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!

  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://0.0.0.0:6379' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://0.0.0.0:6379' }
  end
end
