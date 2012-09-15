require "keyring/version"

module Keyring
  autoload :Key, File.expand_path("../keyring/key",__FILE__)
  
  module ClassMethods
    def namespace_keyring(*keys)
      self.class_variable_set(:@@namespace,keys)
    end
  end
  
  def self.included(mod)
    mod.extend(ClassMethods)
  end
  
  def self.global_namespace=(namespace)
    @@global_namespace = namespace
  end
  
  def keyring
    if self.class.class_variable_defined?(:@@namespace)
      namespace = self.class.class_variable_get(:@@namespace)
      namespace = namespace.map!{|n|n == :global ? @@global_namespace : n} if Keyring.class_variable_defined?(:@@global_namespace)
      Key.new(namespace)
    elsif Keyring.class_variable_defined?(:@@global_namespace)
      Key.new(@@global_namespace)
    else
      Key.new
    end
  end
end
