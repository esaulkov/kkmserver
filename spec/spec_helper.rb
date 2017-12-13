# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib'))

require 'rspec'
require 'webmock/rspec'
require 'vcr'
require 'kkmserver'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end
