if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'
  SimpleCov.start
end

require 'byebug'
require 'ffaker'
require 'itunes_receipt_decoder'
require 'itunes_receipt_encoder'

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
end
