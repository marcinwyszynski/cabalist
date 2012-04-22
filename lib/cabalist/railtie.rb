require 'rails'
require 'active_record'

module Cabalist
  class Railtie < ::Rails::Railtie

    initializer 'cabalist.model_additions', do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end

  end
end