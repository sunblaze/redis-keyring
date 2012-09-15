require "spec_helper.rb"

describe Keyring do
  it "should allow you to include Keyring module so you can make use of a namespaced key easily" do
    class A
      include Keyring
      
      def initialize
        keyring.test.id.to_s.should == "test:id"
      end
    end
    A.new
  end
  
  it "should allow you to set a namespace for the class" do
    class B
      include Keyring
      namespace_keyring "abc"
      
      def initialize
        keyring.test.id.to_s.should == "abc:test:id"
      end
    end
    B.new
  end
  
  it "should allow you to set a namespace for the class, with more levels of scope" do
    class C
      include Keyring
      namespace_keyring "abc","test"
      
      def initialize
        keyring.id.to_s.should == "abc:test:id"
      end
    end
    C.new
  end
  
  it "should allow you to set a global namespace for the entire application" do
    class D
      include Keyring
      
      def initialize
        keyring.test.id.to_s.should == "keyring:test:id"
      end
    end
    Keyring.global_namespace = "keyring"
    D.new
  end
  
  it "should allow you to set a global namespace for the entire application, with more levels of scope" do
    class E
      include Keyring
      
      def initialize
        keyring.id.to_s.should == "keyring:test:id"
      end
    end
    Keyring.global_namespace = ["keyring","test"]
    E.new
  end
  
  it "should allow for the combination of both global and class namespace" do
    class F
      include Keyring
      namespace_keyring :global,"d"
      
      def initialize
        keyring.id.to_s.should == "keyring:test:d:id"
      end
    end
    Keyring.global_namespace = ["keyring","test"]
    F.new
  end
end
