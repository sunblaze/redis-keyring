require "spec_helper.rb"

describe Keyring do
  it "should allow you to include Keyring module so you can make use of a namespaced key easily" do
    class A
      include Keyring
      
      def test
        keyring.test.id.to_s
      end
    end
    expect(A.new.test).to eq("test:id")
  end
  
  it "should allow you to set a namespace for the class" do
    class B
      include Keyring
      namespace_keyring "abc"
      
      def test
        keyring.test.id.to_s
      end
    end
    expect(B.new.test).to eq("abc:test:id")
  end
  
  it "should allow you to set a namespace for the class, with more levels of scope" do
    class C
      include Keyring
      namespace_keyring "abc","test"
      
      def test
        keyring.id.to_s
      end
    end
    expect(C.new.test).to eq("abc:test:id")
  end
  
  it "should allow you to set a global namespace for the entire application" do
    class D
      include Keyring
      
      def test
        keyring.test.id.to_s
      end
    end
    Keyring.global_namespace = "keyring"
    expect(D.new.test).to eq("keyring:test:id")
  end
  
  it "should allow you to set a global namespace for the entire application, with more levels of scope" do
    class E
      include Keyring
      
      def test
        keyring.id.to_s
      end
    end
    Keyring.global_namespace = ["keyring","test"]
    expect(E.new.test).to eq("keyring:test:id")
  end
  
  it "should allow for the combination of both global and class namespace" do
    class F
      include Keyring
      namespace_keyring :global,"d"
      
      def test
        keyring.id.to_s
      end
    end
    Keyring.global_namespace = ["keyring","test"]
    expect(F.new.test).to eq("keyring:test:d:id")
  end
end
