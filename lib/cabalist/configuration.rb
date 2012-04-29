require 'leveldb'
require 'singleton'

module Cabalist
  
  # Cabalist settings.
  #
  # This class is a singleton storing some configuration data of the Cabalist
  # library as used by the application.
  class Configuration
    
    include Singleton
    
    # Path to the local LevelDB instance
    # @return [String] path to the local LevelDB instance
    attr_accessor :db_path
    
    # Cabalist-enabled classes that should be exposed via web GUI
    # @return [Array] classes that should be exposed via web GUI
    attr_accessor :frontend_classes
    
    # Initializer of the Cabalist::Configuration object
    # @return [Cabalist::Configuration] a new Cabalist::Configuration object
    def initialize
      self.frontend_classes = []
    end
    
    # Get the local instance of LevelDB used for caching.
    #
    # @return [LevelDB::DB] instance of LevelDB used by the application
    def database
      LevelDB::DB::new(db_path)
    end
    
  end
end