require 'ai4r'

module Cabalist
  
  # Core functionality of Cabalist.
  #
  # This module is a placeholder for methods that are mixed in with
  # ActiveRecord::Base as well as those that are created by calling
  # acts_as_cabalist method from within the class definition of an
  # inheriting class.
  module ModelAdditions

    _METHOD_UNAVAILABLE = "This method is only available for Cabalist classes"

    # Class helper to add Cabalist functionality to a Rails model.
    #
    # @method acts_as_cabalist(opts={})
    # @scope class
    # @param [Hash] opts An options hash.
    # @option opts [Array] :features
    #   Array of symbols representing name of the model attributes
    #   used as features (predictors) to train the classifier.
    # @option opts [Symbol] :class_variable
    #   Symbol representing the name of the model attribute to be
    #   predicted by the classifier.
    # @option opts [Symbol] :collection (:manually_classified)
    #   Symbol representing the class method used to pull data to be
    #   used to train the classifier. Anything returning either an
    #   ActiveRecord::Relation or an Array of objects of this given class
    #   will do.
    # @option opts [Symbol] :algorithm (:id3)
    #   Symbol representing the algorithm to be used by the classifier.
    #   The library currently supports a number of algorithms provided
    #   by the ai4r gem. Accepted values are as following:
    #   - :hyperpipes for Hyperpipes
    #   - :ib1 for Simple Instance Based Learning
    #   - :id3 for Iterative Dichotomiser 3
    #   - :one_r for One Attribute Rule
    #   - :prism for PRISM
    #   - :zero_r for ZeroR
    # @return [void]
    define_singleton_method(
      :acts_as_cabalist,
      lambda { |opts|
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Automatically classified records.
    #
    # Named scope which returns objects that were classified automatically.
    # That means they have their class variable value set as well as non-nil
    # value of autoclassified_at attribute.
    #
    # @scope class
    # @return [ActiveRecord::Relation] automatically classified records.
    define_singleton_method(
      :auto_classified,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Build the classification model from scratch.
    #
    # You should probably not use this method directly as it will go ahead and
    # compute the classifier anew each and every time instead of looking at
    # any cached versions.
    #
    # @scope class
    # @return [Ai4r::Classifiers::Object] one of classifiers from the 
    #   Ai4r::Classifiers module, depending on the value (and presence) of the
    #   :algorithm option in the acts_as_cabalist method call.
    define_singleton_method(
      :build_model,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Show possible values for the classification.
    #
    # This method will return all unique values of the class variable that the
    # classifier knows about. If any new values have been added after the
    # classifier has last been retrained, they will not find their way here.
    #
    # @scope class
    # @return [Array] an Array containing all unique class variable values.
    define_singleton_method(
      :class_variable_domain,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Get the classification model for a given class.
    #
    # This method will try to find a ready model in the local cache but having
    # failed that will resort to the 'train_model' to create one.
    #
    # @scope class
    # @return [Ai4r::Classifiers::Object] one of classifiers from the 
    #   Ai4r::Classifiers module, depending on the value (and presence) of the
    #   :algorithm option in the acts_as_cabalist method call.
    define_singleton_method(
      :classifier,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Calculate the Cohen's kappa coefficient for the classifier
    # 
    # Cohen's kappa is a measure of classifier quality. For more about this
    # method of measurement, see the relevant article on
    # Wikipedia[link:http://en.wikipedia.org/wiki/Cohen%27s_kappa].
    # @scope class
    # @return [Float] Cohen's kappa coefficient
    define_singleton_method(
      :cohens_kappa,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )
    # Get name of the class variable.
    #
    # This method returns the class variable name (as symbol) as it has
    # been passed to the acts_as_cabalist method call as :class_variable option.
    #
    # @scope class
    # @return [Symbol] name of the class variable.
    define_singleton_method(
      :get_class_variable_name,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Get names of feature attributes.
    #
    # This method returns the Array of attribute names (as symbols) as they have
    # been passed to the acts_as_cabalist method call as :features option.
    #
    # @scope class
    # @return [Array] an Array of symbols representing feature names
    define_singleton_method(
      :get_feature_names,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Manually classified records.
    #
    # Named scope which returns objects that were classified but not
    # automatically, that is they have their class variable value set
    # but autoclassified_at nil.
    #
    # @scope class
    # @return [ActiveRecord::Relation] manually classified records.
    define_singleton_method(
      :manually_classified,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Records that have not yet been classified.
    #
    # Named scope which returns objects that have not been classified.
    # That means that both their class variable and autoclassified_at
    # attribute are nil.
    #
    # @scope class
    # @return [ActiveRecord::Relation] records that have not yet been
    #   classified.
    define_singleton_method(
      :not_classified,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )
    
    # Percantage agreement between classifier and human
    # 
    # This is the number between 0 and 1 which represents how often
    # the classifier and human decision-maker agree. It is one of quality
    # measures of the classifier, albeit a naive one.
    # @scope class
    # @return [Float] percentage agreement score
    define_singleton_method(
      :percentage_ageement,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Percentage of random agreement between classifier and human
    # labeling and the random classifier
    #
    # This is the number between 0 and 1 which represents how often
    # the classifier and human decisions may accidentally be the same,
    # due to sheer randomness rather than actual intelligence reperesented
    # by the classifier.
    # @scope class
    # @return [Float] percentage random agreement
    define_singleton_method(
      :percentage_random_agreement,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Build the classification model from scratch and store it in cache.
    #
    # This method will use a 'build_model' call to create a model from scratch
    # but once it has been created, it will also be immediately stored in the
    # cache for further retrieval using the 'classifier' method.
    #
    # @scope class
    # @return [Ai4r::Classifiers::Object] one of classifiers from the 
    #   Ai4r::Classifiers module, depending on the value (and presence) of the
    #   :algorithm option in the acts_as_cabalist method call.
    define_singleton_method(
      :train_model,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )


    # Get predicted value of the class variable
    #
    # This method will query the classifier of the instance's corresponding
    # class for the predicted classification of this instance, given the value
    # of its features.
    #
    # @method classify()
    # @scope instance
    # @return [Object] predicted value of the class variable
    send(
      :define_method,
      :classify,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Set the class variable to the value suggested by the classifier
    #
    # This method will query the classifier of the instance's corresponding
    # class for the predicted classification of this instance, given the value
    # of its features and then set the class variable to that value.
    #
    # @method classify!()
    # @scope instance
    # @return [self] the current object instance
    send(
      :define_method,
      :classify!,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Value of the class variable.
    #
    # This method returns the value of an attribute passed as the
    # :class_variable option of the acts_as_cabalist method call.
    #
    # @method get_class_variable()
    # @scope instance
    # @return [Object] the value of the class variable
    send(
      :define_method,
      :get_class_variable,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Get an array of features.
    #
    # Returns an Array of values which result from methods passed as the
    # :feature option of the acts_as_cabalist method call. Each of this methods
    # is called upon current instance and results are returned.
    #
    # @method get_features()
    # @scope instance
    # @return [Array] array of values corresponding to attributes selected as
    #   features
    send(
      :define_method,
      :get_features,
      lambda {
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )

    # Set the value of the class variable.
    #
    # This method sets the value of an attribute passed as the
    # :class_variable option of the acts_as_cabalist method call to the new
    # value.
    #
    # @method set_class_variable(new_class_variable)
    # @scope instance
    # @param [Object] new_class_variable the new value of the class variable
    # @return [Object] the new value of the class variable
    send(
      :define_method,
      :set_class_variable,
      lambda { |i|
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )
    
    # Set the value of the class variable.
    #
    # This method sets the value of an attribute passed as the
    # :class_variable option of the acts_as_cabalist method call to the new
    # value and sets the autoclassified_at to nil so that current object is
    # not treated as automatically classified.
    #
    # @method teach(new_class_variable)
    # @scope instance
    # @param [Object] new_class_variable the new value of the class variable
    # @return [DateTime] timestamp of the classification
    send(
      :define_method,
      :teach,
      lambda { |new_class|
        raise NoMethodError, _METHOD_UNAVAILABLE
      }
    )
    

    # @private
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
      
      define_singleton_method(
        :manually_classified,
        lambda {
          where("autoclassified_at IS NULL AND %s IS NOT NULL" %
          options[:class_variable])
        }
      )

      define_singleton_method(
        :auto_classified,
        lambda {
          where("autoclassified_at IS NOT NULL AND %s IS NOT NULL" %
          options[:class_variable])
        }
      )

      define_singleton_method(
        :not_classified,
        lambda {
          where("autoclassified_at IS NULL AND %s IS NULL" %
          options[:class_variable])
        }
      )

      send(
        :define_method,
        :get_features,
        lambda {
          options[:features].map { |f| self.send(f) }
        }
      )

      send(
        :define_method,
        :get_class_variable,
        lambda {
          self.send(options[:class_variable])
        }
      )

      send(
        :define_method,
        :set_class_variable,
        lambda { |c|
          self.send("#{options[:class_variable]}=".to_sym, c) or self
        }
      )

      define_singleton_method(
        :get_feature_names,
        lambda {
          options[:features]
        }
      )

      define_singleton_method(
        :get_class_variable_name,
        lambda {
          options[:class_variable]
        }
      )

      define_singleton_method(
        :build_model,
        lambda {
          classifier::new.build(
            Ai4r::Data::DataSet::new({
              :data_items  => send(collection).map do |el| 
                el.get_features.push(el.get_class_variable)
              end,
              :data_labels => get_feature_names + [get_class_variable_name]
            })
          )
        }
      )

      define_singleton_method(
        :train_model,
        lambda {
          _model = build_model
          Cabalist::Configuration.instance.database.put(name,
              Marshal::dump(_model))
          return _model
        }
      )

      define_singleton_method(
        :classifier,
        lambda {
          _stored = Cabalist::Configuration.instance.database.get(self.name)
          return _stored ? Marshal.load(_stored) : train_model
        }
      )

      define_singleton_method(
        :class_variable_domain,
        lambda {
          self.classifier.data_set.build_domain(-1).to_a
        }
      )

      define_singleton_method(
        :percentage_agreement,
        lambda {
          consistent = manually_classified.all.count do |r|
            r.get_class_variable == r.classify
          end
          return consistent / manually_classified.count.to_f
        }
      )

      define_singleton_method(
        :percentage_random_agreement,
        lambda {
          random_agreement = 0
          records = manually_classified.all
          count = records.size
          human = records.map(&:get_class_variable).group_by { |i| i }
          human.each_pair { |k,v| human[k] = v.size / count.to_f }
          cabalist = records.map(&:classify).group_by { |i| i }
          cabalist.each_pair { |k,v| cabalist[k] = v.size / count.to_f }
          human.each_pair { |k,v| random_agreement += v * cabalist[k] }
          return random_agreement
        }
      )

      define_singleton_method(
        :cohens_kappa,
        lambda {
          rand = percentage_random_agreement
          return (percentage_agreement - rand) / (1 - rand).to_f
        }
      )

      send(
        :define_method,
        :classify,
        lambda {
          begin
            self.class::classifier.eval(get_features)
          rescue
            nil
          end
        }
      )

      send(
        :define_method,
        :classify!,
        lambda {
          set_class_variable(classify)
          self.autoclassified_at = DateTime::now
        }
      )

      send(
        :define_method,
        :teach,
        lambda { |new_class|
          set_class_variable(new_class)
          self.autoclassified_at = nil
        }
      )

    end

  end
end
