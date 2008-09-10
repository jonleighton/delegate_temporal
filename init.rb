require File.dirname(__FILE__) + "/lib/delegate_temporal"

if defined? ActiveRecord::Base
  ActiveRecord::Base.send :include, DelegateTemporal
end
