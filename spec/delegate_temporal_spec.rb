require File.dirname(__FILE__) + "/spec_helper"

class ARStub
  def attributes=(new_attributes)
    new_attributes.each_pair do |key, val|
      send("#{key}=", val)
    end
  end
  
  include DelegateTemporal
end

describe "An object with a temporal delegation of its 'start_time' to an 'appointment' object" do
  before do
    @klass = Class.new(ARStub)
    @klass.delegate_temporal :start_time, :to => :appointment
    @object = @klass.new
    @appointment = stub_everything
    @object.stubs(:appointment).returns(@appointment)
  end
  
  it "should delegate the assignment the multi parameter start_time attributes to the appointment when its attributes are assigned" do
    attrs_to_delegate = {
      "start_time(1i)" => "2008", "start_time(2i)" => "9", "start_time(3i)" => "10",
      "start_time(4i)" => "10", "start_time(5i)" => "37"
    }
    attrs = attrs_to_delegate.merge(:dont_delegate => "this")
    @appointment.expects(:attributes=).with(attrs_to_delegate)
    @object.expects(:dont_delegate=).with("this")
    
    @object.attributes = attrs
  end
end
