# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Hotwire SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

### ITG additions

# Mongoid is an ODM (Object Document Mapper) Framework for MongoDB, written in Ruby
gem 'mongoid', '~> 7.4'
# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.8', '>= 4.8.1'
# A set of udd locale data and translations to internationalize and/or localize your Rails applications.
gem 'rails-i18n', '~> 7.0', '>= 7.0.3'
# Integrate Tailwind CSS with the asset pipeline in Rails
gem 'tailwindcss-rails', '~> 2.0', '>= 2.0.8'
# A gem that provides a client interface for the Sentry error logger
gem 'sentry-rails', '~> 5.3', '>= 5.3.1'
gem 'sentry-ruby', '~> 5.3', '>= 5.3.1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  ### ITG Development/Test additions

  # rspec-rails is a testing framework for Rails
  gem 'rspec-rails'
  # Strategies for cleaning databases using Mongoid. Can be used to ensure a clean state for testing.
  gem 'database_cleaner-mongoid', '~> 2.0', '>= 2.0.1'
  # RSpec matches for Mongoid models, including association and validation matchers.
  gem 'mongoid-rspec', '~> 4.1'
  # factory_bot_rails provides integration between factory_bot and rails 5.0 or newer
  gem 'factory_bot_rails'
  # easily generate fake data: names, addresses, phone numbers, etc.
  gem 'faker'
  # Cucumber Generator and Runtime for Rails
  gem 'cucumber-rails', require: false
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  # (needed by rubymine rspec rn procedure) - helper class for launching cross-platform applications
  gem 'launchy', '~> 2.5'
  gem 'rubocop'
  # pretty print Ruby objects to visualize their structure. Supports custom object formatting via plugins
  gem 'awesome_print', '~> 1.8'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  # Make errors better looking
  gem 'better_errors', '~> 2.9', '>= 2.9.1'
  gem 'binding_of_caller'
  # Use Pry as your rails console
  gem 'pry-rails'
end
