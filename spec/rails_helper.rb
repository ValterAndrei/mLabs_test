require 'spec_helper'
require 'simplecov'

# This ensures that the coverage is above 90% and any changes in the
# future must not drop the coverage by more than 2%
SimpleCov.start do
  add_filter [
    'app/controllers/application_controller.rb',
    'app/controllers/concerns/exception_handler.rb',
    'config',
    'helper',
    'lib',
    'spec'
  ]
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  minimum_coverage 90
  maximum_coverage_drop 2
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
require 'factory_bot'
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
