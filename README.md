Introduction to Cabalist [![Build Status](https://secure.travis-ci.org/marcinwyszynski/cabalist.png?branch=master)](http://travis-ci.org/marcinwyszynski/cabalist)
------------------------

Cabalist is conceived as a simple way of adding some smarts (machine learning capabilities) to your Ruby on Rails models without having to dig deep into mind-boggling AI algorithms. Using it is meant to be as straightforward as adding a few lines to your existing code and running a Rails generator or two.

Installation
------------

First and foremost add Cabalist to your Gemfile as dependency:

```ruby
gem 'cabalist'
```

... and run Bundler command (bundle) to install it and it's own dependencies. Once that is sorted out you will want to run an installer - a generator that comes with Cabalist:

```bash
$ rails g cabalist:install
```

Running this command will create a new initializer (cabalist.rb) in your config/initializers directory, copy gem assets to the public folder and add a route to the GUI. GUI is just one way of interacting with Cabalist so if you do not need it, you may simply remove the route and use Cabalist capabilities through the API it provides.

Basic setup
-----------

In order to add Cabalist capabilities mechanism to your model, you will need to specify which attributes should be used as features (predictors) by a machine learning algorithm and what the class variable for the model should be - that is which attribute Cabalist try to infer. You would do it like this:

```ruby
class Cat < ActiveRecord::Base
  # attributes: name, color, gender, good
  acts_as_cabalist :features       => [:color, :gender],
                   :class_variable => :good
end
```

Before you can use the power of AI, you will have to run another generator that will generate a migration adding a timestamp field to this model - autoclassified_at. This is used to distinguish records that you have clasified yourself from those classified by the algorithm. Later you can use this distinction to validate your model - see if it performs to your satisfaction. You run the generator like this:

```bash
$ rails g cabalist:classifier <Class>
```

...where <Class> should be the name of the class you want to enable Cabalist for. This very generator will also ask whether you want this classifier to also be accessible through the GUI. If you don't use GUI this won't bother you at all. If you do you can still choose what it will expose to the user. It can always be manipulated directly through config/initializers/cabalist.rb file. The attribute of the configuration you should be looking for is called frontend_classes.

Using Cabalist
--------------

Depending on the amount of data to crunch, creating a prediction model may well take a while. The good thing is that this happens only once for each model as once computed, the model is stored in LevelDB (local key-value store).

Now that the Cabalist has set up it's shop, all Cabalist-enabled models gain access to two methods - classify and classify!. The first method will infer the value of the attribute designated as a class variable:

```ruby
cat = Cat::new(:name => 'Filemon', :color => 'white', :gender => 'M')
cat.classify
=> 'y' # ... which means Cabalist thinks this cat is good
```

The latter method will set the class variable field to the predicted value and return object instance (self).

```ruby
cat = Cat::new(:name => 'Filemon', :color => 'white', :gender => 'M')
cat.classify!
=> <Cat:0x00000101433f58 @name="Filemon", @color="white", @gender="M", @good="y">
```

Defaults explained
------------------

By default, the collection Cablist is going to load in order to build a prediction data set is the result of 'manually_classified' scope of the Cabalist-enabled class. This scope is provided for you by Cabalist and looks at your class variable name (whether it is set) and at the autoclassified_at attribute (whethet it is nil). Still, you may want to have a very different idea what data should be used to train your model and you can create an appropriate class method to gather it. You pass that method name as a symbol to :collection option of the act_as_cabalist method. Like so:

```ruby
class Cat < ActiveRecord::Base
  # attributes: name, color, gender, good
  acts_as_cabalist :features       => [:color, :gender],
                   :class_variable => :good,
                   :collection     => :cats_i_care_about
end
```

The other thing you can change is the algorithm used for generating predictions. By default Cabalist uses [ID3](http://en.wikipedia.org/wiki/ID3_algorithm), a decision tree learning algorithm - a rather arbitrary choice, mind you. You can easily change it to any of the following algorithms:
- :hyperpipes for [Hyperpipes](http://code.google.com/p/ourmine/wiki/HyperPipes)
- :ib1 for [Simple Instance Based Learning](http://en.wikipedia.org/wiki/Instance-based_learning)
- :id3 for [Iterative Dichotomiser 3](http://en.wikipedia.org/wiki/ID3_algorithm)
- :one_r for [One Attribute Rule](http://www.soc.napier.ac.uk/~peter/vldb/dm/node8.html)
- :prism for [PRISM](http://www.sciencedirect.com/science/article/pii/S0020737387800032)
- :zero_r for [ZeroR](http://chem-eng.utoronto.ca/~datamining/dmc/zeror.htm)

All algorithms come from an excellent [ai4r](https://github.com/SergioFierens/ai4r) gem. You can choose a specific algorithm to use by your Cabalist model by passing one of the options mentioned above to the :algorithm option like so:

```ruby
class Cat < ActiveRecord::Base
  # attributes: name, color, gender, good
  acts_as_cabalist :features       => [:color, :gender],
                   :class_variable => :good,
                   :algorithm      => :prism
end
```

You can use different algorithms in different models and I would encourage you to give each one a go - perhaps except for ZeroR which is only really good for benchmarking (all it does is return the most popular result of a class variable).

Helping your Cabalist
---------------------

So far we've used raw data, derived directly from attributes in your model. You may want to pre-process your data before you pass it to Cabalist. Please remember that you know your domain best and the more smarts you put into AI, the more smarts it will throw back at you. So let's imagine that instead of passing the color attribute directly, we may want to have a method which will tell us whether the color is light or dark - presumably this has something to do with a cat's character:

```ruby
class Cat < ActiveRecord::Base
  # attributes: name, color, gender, good
  acts_as_cabalist :features       => [:light_or_dark, :gender],
                   :class_variable => :good

  def light_or_dark
    if %w(white yellow orange grey).include?(color)
      'light'
    else
      'dark'
    end
  end
end
```

Ok, so much for now. Happy categorizing :)