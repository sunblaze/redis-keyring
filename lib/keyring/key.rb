require 'pp'

module Keyring
  class Key
    attr_accessor :legend
  
    DEFAULT_KEY_DELIMITER = ':'
  
    def initialize(keys = nil,delimiter = DEFAULT_KEY_DELIMITER)
      @delimiter = delimiter
      @key = keys && [keys].flatten.join(@delimiter)
      @legend = @key
    end
  
    def [](*keys)
      legend = keys.map{|k| k.tainted? ? "*" : "@"}.join(@delimiter)
      spawn(keys,legend)
    end
    
    def to_s
      @@legends[@legend] ||= true
      @key
    end
    
    def to_ary # had issues when flatten tried to flatten the key with method_missing
      nil
    end
    
    def method_missing(sym,*args)
      if args.empty?
        spawn(sym,sym)
      elsif args.size == 1
        val = args.first
        spawn(val,val.tainted? ? "*#{sym}" : "@#{sym}")
      end
    end

    @@legends = {}
    def self.print_stats
      @@at_exit = true
      at_exit do
        if @@at_exit
          pp @@legends.keys
        end
      end
    end
    
    def self.generate_stats(file_path)
      @@at_exit = true
      at_exit do
        if @@at_exit
          File.open(file_path,"w") do |file|
            file << "# Legend (* - tainted variables), (@ - clean variables)\n"
            @@legends.keys.sort.each do |key|
              file << "#{key}\n"
            end
          end
        end
      end
    end
    
    def self.dont_at_exit
      @@at_exit = false
    end
    
    private
    def spawn(keys,legend)
      new_keys = @key ? [@key,keys] : [keys]
      self.class.new(new_keys,@delimiter).tap do |new_key|
        new_key.legend = [@legend,legend].join(@delimiter)
      end
    end
  end
end
