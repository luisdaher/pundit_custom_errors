require 'rubygems'
require 'bundler'
require 'pundit_custom_errors'
require 'pundit'
require 'pry'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

Bundler.setup(:default, :test, :development)

RSpec.configure do |config|
  config.mock_with :rspec
end
