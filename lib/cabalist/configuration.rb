require 'leveldb'
require 'singleton'

module Cabalist
  class Configuration
    
    include Singleton
    
    attr_accessor :db_path, :frontend_classes
    
    def initialize
      self.frontend_classes = []
    end
    
    def database
      LevelDB::DB::new(db_path)
    end
    
  end
end