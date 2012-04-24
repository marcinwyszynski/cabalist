require 'ai4r'

module Cabalist
  module ModelAdditions
    
    def acts_as_cabalist(options = {})
      
      # Make sure that all required options are set
      raise 'No features specified' \
          unless options.has_key?(:features)
      raise 'Expecting an Array of features' \
          unless options[:features].instance_of?(Array)
      raise 'No class variable specified' \
          unless options.has_key?(:class_variable)

      # Set some sensible defaults for other options, if required
      collection = options[:collection] || :manually_classified
      algorithm  = options[:algorithm]  || :id3
      
      # Select an algorithm for the classifier
      classifier = case algorithm
                   when :hyperpipes then ::Ai4r::Classifiers::Hyperpipes
                   when :ib1        then ::Ai4r::Classifiers::IB1
                   when :id3        then ::Ai4r::Classifiers::ID3
                   when :one_r      then ::Ai4r::Classifiers::OneR
                   when :prism      then ::Ai4r::Classifiers::Prism
                   when :zero_r     then ::Ai4r::Classifiers::ZeroR
                   else raise 'Unknown algorithm provided'
                   end
      
      # Create scopes
      scope :manually_classified,
          where("autoclassified_at IS NULL AND %s IS NOT NULL" %
          options[:class_variable])
      scope :auto_classified,
          where("autoclassified_at IS NOT NULL AND %s IS NOT NULL" %
          options[:class_variable])
      scope :not_classified,
          where("autoclassified_at IS NULL AND %s IS NULL" %
          options[:class_variable])

      # Return object as an Array of features
      send(:define_method, :get_features, lambda {
        options[:features].map { |f| self.send(f) }
      })
      
      # Return the value of a class variable
      send(:define_method, :get_class_variable, lambda {
        self.send(options[:class_variable])
      })
      
      # Set the value of the class variable
      send(:define_method, :set_class_variable, lambda { |c|
        self.send("#{options[:class_variable]}=".to_sym, c) or self
      })
      
      # Return an Array of feature names (attributes/methods)
      send(:define_singleton_method, :get_feature_names, lambda {
        options[:features]
      })
      
      # Return the name of a class variable
      send(:define_singleton_method, :get_class_variable_name, lambda {
        options[:class_variable]
      })
      
      # Build a prediction model from scratch
      send(:define_singleton_method, :build_model, lambda {
        classifier::new.build(
          Ai4r::Data::DataSet::new({
            :data_items  => send(collection).map do |el| 
              el.get_features.push(el.get_class_variable)
            end,
            :data_labels => get_feature_names + [get_class_variable_name]
          })
        )
      })
      
      # Build a prediction model and store it in the LevelDB
      send(:define_singleton_method, :train_model, lambda {
        _model = build_model
        Cabalist::Configuration.instance.database.put(name,
            Marshal::dump(_model))
        return _model
      })
      
      # Return prediction model for the class
      send(:define_singleton_method, :classifier, lambda {
        _stored = Cabalist::Configuration.instance.database.get(self.name)
        return _stored ? Marshal.load(_stored) : train_model
      })

      # Show possible values for the classification.
      define_singleton_method(
        :class_variable_domain,
        lambda { self.classifier.data_set.build_domain(-1).to_a }
      )
    
      # Create a 'classify' method which will provide a classification
      # for any new object.
      send(:define_method, :classify, lambda {
        begin
          self.class::classifier.eval(get_features)
        rescue
          nil
        end
      })
  
      # Create a 'classify!' method which will get a classification
      # for any new object and apply it to the current instance.
      send(:define_method, :classify!, lambda {
        set_class_variable(classify)
        self.autoclassified_at = DateTime::now
      })
      
      # Create a 'teach' method which will manually set the classificaiton
      # and set the autoclassification timestamp to nil so that the new entry
      # can be treated as basis for learning.
      send(:define_method, :teach, lambda { |new_class|
        set_class_variable(new_class)
        self.autoclassified_at = nil
      })

    end
    
  end
end