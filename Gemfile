source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.0.2"

gem "active_model_serializers", "~> 0.10.2"
gem "active_storage_validations", "0.8.2"
gem "axlsx_rails"
gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.4", require: false
gem "cancancan"
gem "config"
gem "delayed_job_active_record"
gem "devise", "~> 4.1"
gem "faker"
gem "figaro"
gem "image_processing", "1.9.3"
gem "jbuilder", "~> 2.7"
gem "mini_magick", "4.9.5"
gem "mysql2", "~> 0.5"
gem "net-smtp"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-github", github: "omniauth/omniauth-github", branch: "master"
gem "omniauth-google-oauth2"
gem "pagy"
gem "paranoia", "~> 2.2"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.6"
gem "rails-i18n"
gem "ransack"
gem "redis", "~> 3.0"
gem "redis-namespace"
gem "sass-rails", ">= 6"
gem "sidekiq"
gem "simplecov"
gem "simplecov-rcov"
gem "tinymce-rails"
gem "toastr-rails"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "pry-rails"
end

group :development, :test do
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

group :development, :test do
  gem "database_cleaner", "~> 1.5", ">= 1.5.3"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.1"
  gem "shoulda-matchers"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
