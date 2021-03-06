require "spec_helper.rb"
require "tempfile"

module Keyring
  describe Key do
    before(:each) do
      Key.class_variable_set(:@@legends,{})
    end
  
    describe "#initialize" do
      it "should take one string as a key" do
        n = Key.new("key_spec")
        expect(n.to_s).to eq("key_spec")
      end
      
      it "should take an optional delimiter string" do
        n = Key.new(["key_spec","users"],".")
        expect(n.to_s).to eq("key_spec.users")
      end
      
      it "should take nil as the first argument or no arguments" do
        expect(Key.new.simple_key.to_s).to eq("simple_key")
        expect(Key.new(nil).simple_key.to_s).to eq("simple_key")
      end
    end
    describe "#[]" do
      it "should take one string as a key" do
        n = Key.new("key_spec")["a"]
        expect(n.to_s).to eq("key_spec:a")
      end
      it "should take two strings as keys" do
        n = Key.new("key_spec")["a","b"]
        expect(n.to_s).to eq("key_spec:a:b")
      end
    end
    describe "#legend" do
      it "should be the same as the key, when not provided" do
        n = Key.new("key_spec")
        expect(n.legend).to eq("key_spec")
      end
      it "should have a at symbol for untainted values" do
        n = Key.new("key_spec")["hello"]
        expect(n.legend).to eq("key_spec:@")
      end
      it "should have a star for tainted values" do
        h = "hello"
        h.taint
        n = Key.new("key_spec")[h]
        expect(n.legend).to eq("key_spec:*")
      end
    end
    describe "#method_missing" do
      it "should allow for easy identification of static values in the keys" do
        n = Key.new("key_spec").a_list
        expect(n.to_s).to eq("key_spec:a_list")
        expect(n.legend).to eq("key_spec:a_list")
      end
      
      it "should allow for named values in the key's legend" do
        n = Key.new("key_spec").id(1).a_list
        expect(n.to_s).to eq("key_spec:1:a_list")
        expect(n.legend).to eq("key_spec:@id:a_list")
      end
      
      it "should allow for named values in the key's legend" do
        tainted_id = "yes"
        tainted_id.taint
        n = Key.new("key_spec").id(tainted_id).a_list
        expect(n.to_s).to eq("key_spec:yes:a_list")
        expect(n.legend).to eq("key_spec:*id:a_list")
      end
    end
    describe ".print_stats" do
      it "should print the legend to stdout, on exit" do
        Key.new("test_print_stats").to_s
        expect(Key).to receive(:at_exit) do |&proc|
          expect(Key).to receive(:pp).with(["test_print_stats"])
          proc.call
        end
        Key.print_stats
      end
    end
    describe ".generate_stats" do
      it "should write the legend to file, on exit" do
        Key.new("test_print_stats").to_s
        expect(Key).to receive(:at_exit) do |&proc|
          proc.call
        end
        
        file = Tempfile.new('generate_stats.log')
        Key.generate_stats(file.path)
        expect(file.read).to eq("# Legend (* - tainted variables), (@ - clean variables)\ntest_print_stats\n")
        file.close
      end
    end
    describe ".dont_at_exit" do
      it "should not print the legend to stdout, on exit" do
        Key.new("test_print_stats").to_s
        the_proc = nil
        expect(Key).to receive(:at_exit) do |&proc|
          the_proc = proc
        end
        expect(Key).not_to receive(:pp)
        
        Key.print_stats
        Key.dont_at_exit
        the_proc.call
      end
    end
  end
end
