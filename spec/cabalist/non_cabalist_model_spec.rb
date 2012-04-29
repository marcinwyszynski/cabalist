require 'spec_helper'

describe Cabalist::ModelAdditions do
  
  with_model :Dog do
    
    table do |t|
      t.string    :color
      t.boolean   :evil
      t.timestamp :autoclassified_at
    end

    model do
      extend Cabalist::ModelAdditions
    end

  end
  
  before(:each) do
    @new_dog = Dog::new(:color => 'white', :evil => false)
  end
  
  # == Test class (static) methods =================================== #
  it "Should not recognize the 'auto_classified' method" do
    expect { Dog::auto_classified }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'build_model' method" do
    expect { Dog::build_model }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'class_variable_domain' method" do
    expect { Dog::class_variable_domain }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'cohens_kappa' method" do
    expect { Dog::cohens_kappa }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'get_class_variable_name' method" do
    expect { Dog::get_class_variable_name }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'get_feature_names' method" do
    expect { Dog::get_feature_names }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'manually_classified' method" do
    expect { Dog::manually_classified }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'not_classified' method" do
    expect { Dog::not_classified }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'percentage_ageement' method" do
    expect { Dog::percentage_ageement }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'percentage_random_agreement' method" do
    expect { Dog::percentage_random_agreement }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'train_model' method" do
    expect { Dog::train_model }.to raise_error NoMethodError
  end
  # == END =========================================================== #
  
  # == Test instance methods ========================================= #
  it "Should not recognize the 'classify' method" do
    expect { @new_dog.classify }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'classify!' method" do
    expect { @new_dog.classify! }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'get_class_variable' method" do
    expect { @new_dog.get_class_variable }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'get_features' method" do
    expect { @new_dog.get_features }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'set_class_variable' method" do
    expect { @new_dog.set_class_variable(false) }.to raise_error NoMethodError
  end
  
  it "Should not recognize the 'teach' method" do
    expect { @new_dog.teach(false) }.to raise_error NoMethodError
  end
  # == END =========================================================== #
  
end
