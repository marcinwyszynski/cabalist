require "cabalist/version"
require "cabalist/configuration"
require "cabalist/frontend"
require "cabalist/model_additions"
require "cabalist/railtie" if defined? Rails

# Minimum setup machine learning (classification) library for Ruby on Rails
# applications.
module Cabalist

  # Configure the application
  #
  # @return [Cabalist::Configuration] library configuration singleton
  def self.configure
    yield Cabalist::Configuration.instance
  end

end
