module Cabalist
  class ClassifierGenerator < Rails::Generators::NamedBase
    desc <<-EOF
      This generator creates a migration to add autoclassified_at attribute
      to a chosen ActiveRecord model. The model name should be supplied as
      and attrubute to the generator:
      rails generate cabalist:classifier <ModelName>
    EOF
    
    include Rails::Generators::Migration
    
    source_root File.expand_path('../templates/', __FILE__)
    argument :name, :type => :string
    
    def self.next_migration_number(dirname)
      Time.now.strftime("%Y%m%d%H%M%S")
    end
    
    def create_migration
      migration_template("migrations/add_cabalist.rb.erb",
          "db/migrate/add_cabalist_to_#{name.tableize}.rb")
    end
    
    def add_to_gui_if_necessary
      add_to_gui = ''
      until %w(y Y n N).include?(add_to_gui)
        add_to_gui = ask "Would you like to have access to this model through GUI dashboard? (Y/n) "
      end
      if %w(Y y).include?(add_to_gui)
        inject_into_file "config/initializers/cabalist.rb",
                         "\n  config.frontend_classes << #{name}",
                         :before => "\nend"
      end
    end
    
  end
end
