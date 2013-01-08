require 'rspec'
require 'enid'

class RSpec::Core::ExampleGroup
  def enid_eval(*sexps)
    scope = Enid::Scope.new
    sexps.map {|s| scope._eval s}.last
  end
end

RSpec.configure do |cfg|
  cfg.color_enabled = true
end

