require 'rubygems'
require 'active_support'

class Module
  def named_delegate(*methods)
    options = methods.pop
    unless options.is_a?(Hash) && to = options[:to]
      raise ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter)."
    end

    methods.each do |method|
      module_eval(<<-EOS, "(__DELEGATION__)", 1)
       def #{to}_#{method}(*args, &block)
         #{to} ? #{to}.__send__(#{method.inspect}, *args, &block) : nil
       end
     EOS
    end
  end
end
