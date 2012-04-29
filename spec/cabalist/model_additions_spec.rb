require 'spec_helper'

describe Cabalist::ModelAdditions do
  
  with_model :Cat do
    
    table do |t|
      t.string    :color
      t.boolean   :evil
      t.timestamp :autoclassified_at
    end

    model do
      extend Cabalist::ModelAdditions

      def self.test_cats
        result = []
        10.times { result << Cat::create(:color => 'white', :evil => false) }
        10.times { result << Cat::create(:color => 'black', :evil => true) }
        return result
      end
    
      acts_as_cabalist :class_variable => :evil,
                       :features       => [:color],
                       :collection     => :test_cats
    end

  end
  
  before(:each) do
    @new_cat   = Cat::new(:color => 'white', :evil => false)
    @white_cat = Cat::new(:color => 'white')
    @black_cat = Cat::new(:color => 'black')
  end
  
  # == Test class (static) methods =================================== #
  it "Should return feature names" do
    Cat::get_feature_names.should eq [:color]
  end
  
  it "Shoud return class variable name" do
    Cat::get_class_variable_name.should eq :evil
  end
  
  it "Should be able to build a classifier" do
    Cat::build_model.should be_an_instance_of Ai4r::Classifiers::ID3
  end
  
  it "Should be able to train a classifier" do
    Cat::train_model.should be_an_instance_of Ai4r::Classifiers::ID3
  end
  
  it "Should be able to return a classifier" do
    Cat::classifier.should be_an_instance_of Ai4r::Classifiers::ID3
  end
  
  it "Should return class variable value domain" do
    Cat::class_variable_domain.should eq [false, true]
  end
  
  it "Should return percentage agreement between 0 and 1" do
    Cat::test_cats
    Cat::percentage_agreement.should be_between(0, 1)
  end
  
  it "Should return percentage random agreement between 0 and 1" do
    Cat::test_cats
    Cat::percentage_random_agreement.should be_between(0, 1)
  end
  
  it "Should return Cohen's kappa between -1 and 1" do
    Cat::test_cats
    Cat::cohens_kappa.should be_between(-1, 1)
  end
  # == END =========================================================== #
  
  # == Test instance methods ========================================= #
  it "Should return feature values" do
    @new_cat.get_features.should eq ['white']
  end
  
  it "Should return class variable value" do
    @new_cat.get_class_variable.should eq false
  end
  
  it "Should be able to set class variable accordingly" do
    @new_cat.set_class_variable(true)
    @new_cat.evil?.should eq true
  end
  
  it "Should be able to predict the value of class variable" do
    @white_cat.classify.should eq false
    @black_cat.classify.should eq true
  end
  
  it "Should not timestamp an object when calling \#classify" do
    @white_cat.classify
    @white_cat.autoclassified_at.should eq nil
  end
  
  it "Should autoclassify an object when calling \#classify!" do
    @white_cat.classify!
    @white_cat.autoclassified_at.should be_an_instance_of DateTime
    @white_cat.evil?.should eq false
    
    @black_cat.classify!
    @black_cat.autoclassified_at.should be_an_instance_of DateTime
    @black_cat.evil?.should eq true
  end
  
  it "Should remove an autoclassification timestamp when calling \#teach" do
    @black_cat.classify!
    @black_cat.teach(false)
    @black_cat.autoclassified_at.should eq nil
    @black_cat.evil?.should eq false
  end
  # == END =========================================================== #
  
end