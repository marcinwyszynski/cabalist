require 'ai4r'

module Cabalist
  module ModelAdditions
    
    def acts_as_cabalist(options = {})
      
      collection = options[:collection] || :manually_classified
      algorithm  = options[:algorithm]  || :id3
      
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
      
      send(:define_method, :get_features, lambda {
        options[:features].map { |f| self.send(f) }
      })
      
      send(:define_method, :get_class_variable, lambda {
        self.send(options[:class_variable])
      })
      
      send(:define_method, :set_class_variable, lambda { |c|
        self.send("#{options[:class_variable]}=".to_sym, c) or self
      })
      
      send(:define_singleton_method, :get_feature_names, lambda {
        options[:features]
      })
      
      send(:define_singleton_method, :get_class_variable_name, lambda {
        options[:class_variable]
      })
      
      send(:define_singleton_method, :classifier, lambda {
        classifier::new.build(
          Ai4r::Data::DataSet::new({
            :data_items  => send(collection).map do |el| 
              el.get_features.push(el.get_class_variable)
            end,
            :data_labels => get_feature_names + [get_class_variable_name]
          })
        )
      })

      # Show possible values for the classification.
      define_singleton_method(
        :class_variable_domain,
        lambda { classifier.data_set.build_domain(-1).to_a }
      )
    
      # Create a 'classify' method which will provide a classification
      # for any new object.
      send(:define_method, :classify, lambda {
        begin
          self.class::classifier.eval(get_signals)
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
        set_classification(new_class)
        self.autoclassified_at = nil
      })

    end
    
  end
end