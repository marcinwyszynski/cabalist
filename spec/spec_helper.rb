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

Cabalist.configure do |config|
  config.db_path = '/tmp/cabalist_level.db'
end

RSpec::Matchers.define :be_between do |low,high|
  match do |actual|
    @low, @high = low, high
    actual.between? low, high
  end
  
  failure_message_for_should do |actual|
    "expected to be between #{@low} and #{@high}, but was #{actual}"
  end
  failure_message_for_should_not do |actual|
    "expected not to be between #{@low} and #{@high}, but was #{actual}"
  end
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
