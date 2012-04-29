require 'rails'
require 'active_record'

module Cabalist
  
  # This is the link between Rails application and the Cabalist gem
  #
  # This Railtie extends ActiveRecord::Base with Cabalist::ModelAdditions
  # once ActiveRecord is loaded. It also adds relevant Rake tasks to the
  # application which provide CLI to the Cabalist functionality.
  class Railtie < ::Rails::Railtie

    initializer 'cabalist.model_additions' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end
    
    rake_tasks do
      load 'tasks/retrain.rake'
    end

  end
end