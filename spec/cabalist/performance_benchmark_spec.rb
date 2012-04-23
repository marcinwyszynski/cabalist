require 'benchmark'
require 'spec_helper'

RSpec::Matchers.define :take_less_than do |n|
  chain :seconds do; end

  match do |block|
    @elapsed = Benchmark.realtime do
      block.call
    end
    @elapsed <= n
  end

end

describe Cabalist::ModelAdditions do
  
  with_model :Cat do
    
    table do |t|
      t.string    :color
      t.string    :gender
      t.boolean   :evil
      t.timestamp :autoclassified_at
    end

    model do
      extend Cabalist::ModelAdditions

      # Overall, the model will cover 8,000 cats. The idea is:
      # - all white cats are good
      # - all black cats are evil
      # - all grey female cats are good
      # - all grey make cats are evil
      # - all ginger female cats are evil
      # - all ginger male cats are good
      def self.create_test_cats
        result = []
        1000.times { result << Cat::create(:color => 'white',  :gender => 'female', :evil => false) }
        1000.times { result << Cat::create(:color => 'white',  :gender => 'male',   :evil => false) }
        1000.times { result << Cat::create(:color => 'black',  :gender => 'female', :evil => true) }
        1000.times { result << Cat::create(:color => 'black',  :gender => 'male',   :evil => true) }
        1000.times { result << Cat::create(:color => 'grey',   :gender => 'female', :evil => false) }
        1000.times { result << Cat::create(:color => 'grey',   :gender => 'male',   :evil => true) }
        1000.times { result << Cat::create(:color => 'ginger', :gender => 'female', :evil => true) }
        1000.times { result << Cat::create(:color => 'ginger', :gender => 'male',   :evil => false) }
        return result
      end
    
      acts_as_cabalist :class_variable => :evil,
                       :features       => [:color, :gender],
                       :collection     => :all
    end

  end
  
  it "Creates a model within less than 5 seconds" do
    Cat::create_test_cats
    Cat::count.should eq 8000
    expect do
      Cat::classifier
    end.to take_less_than(5).seconds
  end
  
  it "Classifies a new cat correctly and in less than 0.1 seconds" do
    Cat::create_test_cats
    Cat::count.should eq 8000
    Cat::train_model
    c = Cat::new(:color => 'white', :gender => 'male')
    c.classify.should eq false
    expect do
      c.classify
    end.to take_less_than(0.1).seconds
  end
  
end