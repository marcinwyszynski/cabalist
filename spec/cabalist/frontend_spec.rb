require 'spec_helper'

describe Cabalist::Frontend do
  
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
        100.times { result << Cat::create(:color => 'white', :evil => false) }
        100.times { result << Cat::create(:color => 'black', :evil => true) }
        return result
      end
    
      acts_as_cabalist :class_variable => :evil,
                       :features       => [:color],
                       :collection     => :test_cats
    end

  end
  
  before(:each) do
    Cat::test_cats
    Cabalist::Configuration.instance.frontend_classes = [Cat]
  end
  
  it "should respond to GET at /" do
    get '/'
    last_response.should be_ok
    last_response.body.should match /Cats/
  end
  
  it "should list all records for Cat" do
    get "/cat/all/1"
    last_response.should be_ok
  end
  
  it "should list non-classified records for Cat" do
    get "/cat/none/1"
    last_response.should be_ok
  end
  
  it "should list manually classified records for Cat" do
    get "/cat/manual/1"
    last_response.should be_ok
  end
  
  it "should list automatically classified records for Cat" do
    get "/cat/auto/1"
    last_response.should be_ok
  end
  
  it "should set the value of class variable for a Cat with a given ID" do
    cat = Cat.first
    post "/cat/teach/#{cat.id}", { :classification => true, :classification_freeform => '' },
                                 { :referer => '/cat/all/1' }
    last_response.should be_redirect
  end
  
  it "should automatically classify the Cat with a given ID" do
    cat = Cat.first
    post "/cat/autoclassify/#{cat.id}", { :referer => '/cat/manual/1' }
    last_response.should be_redirect
  end
  
end