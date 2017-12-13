# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv', '~> 2.2.1'
gem 'rest-client', '>= 2.0.2'
gem 'rubocop', '~> 0.49.1', require: false

group :development, :test do
  gem 'rake', '~> 10.4.2'
  gem 'rspec', '~> 3.7.0'
  gem 'vcr'
  gem 'webmock'
end
