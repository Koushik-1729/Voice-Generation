source "https://rubygems.org"

# Explicitly require psych to fix bundler conflict
# gem "psych", "~> 5.0"

gem "rails", "~> 7.1.0"
group :production do
  gem "pg", "~> 1.6"
end

group :development, :test do
  gem "sqlite3", "~> 2.8"
end
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "sprockets-rails"

# Background job processing
gem "sidekiq", "~> 8.1"
gem "redis", "~> 5.0"

# External services
gem "httparty", "~> 0.21"
gem "cloudinary", "~> 1.28"

# Rate limiting
gem "rack-attack", "~> 6.7"

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false


# Added for Voice Generation Project
gem "dotenv-rails", groups: [:development, :test]
gem "faraday"

group :development, :test do
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.4"
  gem "debug", platforms: %i[ mri windows ]
  gem "webmock", "~> 3.23"
  gem "shoulda-matchers", "~> 6.0"
end

group :development do
  gem "web-console"
end
