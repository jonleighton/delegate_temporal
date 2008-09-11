module DelegateTemporal
  module ClassMethods
    def temporal_delegations
      @temporal_delegations ||= {}
    end
    
    def delegate_temporal(*args)
      attrs, options = args[0..-2], args.last
      attrs.each do |attr|
        delegate attr, "#{attr}=", :to => options[:to]
        (temporal_delegations[options[:to].to_s] ||= []) << attr.to_s
      end
    end
  end
  
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :alias_method_chain, :attributes=, :temporal_delegation
  end
  
  def attributes_with_temporal_delegation=(new_attributes)
    self.class.temporal_delegations.each_pair do |to, attribute_names|
      attribute_keys_to_delegate = []
      attribute_names.each do |attribute_name|
        attribute_keys_to_delegate += new_attributes.keys.find_all { |key| key.to_s =~ /^#{attribute_name}(\(.+\))?$/ }
      end
      
      attributes_to_delegate = attribute_keys_to_delegate.inject({}) do |mem, key|
        mem[key] = new_attributes.delete(key)
        mem
      end
      
      send(to).attributes = attributes_to_delegate unless attributes_to_delegate.empty?
    end
    self.attributes_without_temporal_delegation = new_attributes
  end
end
