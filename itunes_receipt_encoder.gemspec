# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'itunes_receipt_encoder/version'

Gem::Specification.new do |spec|
  spec.name = 'itunes_receipt_encoder'
  spec.version = ItunesReceiptEncoder::VERSION
  spec.summary = 'Generate iTunes receipts'
  spec.description = <<-EOF
    Generate iTunes receipts
  EOF
  spec.license = 'MIT'
  spec.authors = ['mbaasy.com']
  spec.email = 'hello@mbaasy.com'
  spec.homepage = 'https://github.com/mbaasy/itunes_receipt_encoder'

  spec.required_ruby_version = '>= 2.0.0'

  spec.files = Dir['lib/**/*.rb'].reverse
  spec.require_paths = ['lib']

  spec.add_dependency 'CFPropertyList', '~> 2.3'

  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubygems-tasks', '~> 0.2'
  spec.add_development_dependency 'simplecov', '~> 0.10'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'rubocop', '~> 0.33'
  spec.add_development_dependency 'webmock', '~> 1.22'
  spec.add_development_dependency 'byebug', '~> 8.2'
  spec.add_development_dependency 'ffaker', '~> 2.1'
  spec.add_development_dependency 'itunes_receipt_decoder', '0.2.3'
end
