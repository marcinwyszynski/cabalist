require 'spec_helper'

describe Cabalist::ModelAdditions do
  
  with_model :Cat do
    
    table do |t|
      t.string  :color
      t.boolean :evil

    model do
      extend Cabalist::ModelAdditions

      def self.test_cats
        result = []
        10.times { result << Cat::create(:color => 'white', :evil => false) }
        10.times { result << Cat::create(:color => 'black', :evil => true) }
        return result
      end
    
      acts_as_cabalist :class_varialbe => :evil,
                       :features       => [:color],
                       :collection     => :test_cats
    end

  end
  
  it "Should create a classifier" do
    Cat::classifier.should_not raise_error(NameError)
  end
  
end
  
end