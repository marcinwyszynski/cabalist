require 'active_record'
require 'cabalist'
require 'rack/test'
require 'sinatra'
require 'sqlite3'
require 'with_model'

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "/tmp/cabalist.sqlite3"
)

Cabalist.config do |c|
  c.db_path = '/tmp/cabalist_level.db'
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend  WithModel
end

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Cabalist::Frontend
end
