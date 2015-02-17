require 'rubygems'
require 'bundler'
require 'pundit_custom_errors'
require 'factory_girl'

Bundler.setup(:default, :test, :development)

require 'pry'

RSpec.configure do |config|
  config.mock_with :rspec
  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.find_definitions
end
