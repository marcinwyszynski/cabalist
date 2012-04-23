require 'active_record'
require 'cabalist'
require 'sqlite3'
require 'with_model'

ActiveRecord::Base.establish_connection(
  :adapter   => "sqlite3",
  :database  => "/tmp/cabalist.sqlite3"
)

Cabalist.config do |c|
  c.db_path = '/tmp/cabalist_level.db'
end

RSpec.configure do |config|
  config.extend WithModel
end