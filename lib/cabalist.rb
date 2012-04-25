require "cabalist/version"
require "cabalist/configuration"
require "cabalist/frontend"
require "cabalist/model_additions"
require "cabalist/railtie" if defined? Rails

module Cabalist
  
  def self.configure
    yield Cabalist::Configuration.instance
  end
  
end
