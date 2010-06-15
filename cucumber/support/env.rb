# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'cucumber/rails/rspec'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

require 'webrat'
require 'webrat/core/matchers'
require "#{RAILS_ROOT}/features/support/factories.rb"

Webrat.configure do |config|
  config.mode = :selenium
  config.open_error_files = false # Set to true if you want error pages to pop up in the browser
end

ActionController::Base.allow_rescue = false

Cucumber::Rails::World.use_transactional_fixtures = true
#require 'database_cleaner'

#DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  setup do |session|
    session.host! "localhost:3001"
  end
end
