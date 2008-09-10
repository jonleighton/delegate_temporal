require "rubygems"
require "active_support"
require "spec"
require File.dirname(__FILE__) + "/../init"

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
