module Cabalist
  class InstallGenerator < Rails::Generators::Base
    desc <<-EOF
      This generator installs the Cabalist initializer and 
      adds the route to Cabalist GUI (Cabalist::Frontend).
      Usage:
      rails generate cabalist:install <ModelName>
    EOF
    
    source_root File.expand_path('../templates/', __FILE__)
    
    def copy_initializer
      copy_file "initializers/cabalist.rb",
                "config/initializers/cabalist.rb"
    end
    
    def copy_assets
      directory "public/", "public/"
    end
    
    def add_route
      route "match '/cabalist' => Cabalist::Frontend, :anchor => false, :as => :cabalist"
    end
    
  end
end