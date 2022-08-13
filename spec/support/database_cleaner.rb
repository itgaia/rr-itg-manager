# frozen_string_literal: true

require 'database_cleaner-mongoid'

RSpec.configure do |config|
  DatabaseCleaner[:mongoid].strategy = [:deletion]

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
    DatabaseCleaner.strategy = :deletion
  end
end
