source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.4"

gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "ruby-openai", "~> 3.7"
gem "pdf-reader", "~> 2.11"
gem "matrix", "~> 0.4.2"
gem "shrine", "~> 3.4"
gem "marcel", "~> 1.0"
gem "sidekiq", "<7.0"
gem "dotenv-rails", "~> 2.8"
gem "aws-sdk-s3", "~> 1.119"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "simplecov", "~> 0.22.0", require: false
  gem "faker", "~> 3.1"
  gem "rails-controller-testing", "~> 1.0"
end

group :development do
  gem "web-console"
  gem "hotwire-livereload", "~> 1.2"
  gem "pycall", "~> 1.4"
  gem "redis", "~> 4.0"
end

gem "annotate", "~> 3.2"
