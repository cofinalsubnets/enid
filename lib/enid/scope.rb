module Enid
  class Scope
    attr_reader :bindings
    class << self; attr_accessor :bindings end
    @bindings = {}
    include Lib::Std

    def self.inherited(klass)
      klass.bindings = self.bindings.dup
    end

    def initialize(binds = {})
      @bindings = self.class.bindings.dup.merge(binds)
    end

    def new(binds = {})
      Class.new(self.class).new(@bindings.merge binds)
    end

    def self.depth
      self == Scope ? 0 : superclass.depth+1
    end

    def depth
      self.class.depth
    end

    def resolve(obj)
      if obj.is_a?(Symbol)
        bindings.has_key?(obj) ? bindings[obj].bind(self) : mapply(obj)
      elsif [Data::Func, UnboundMethod].include? obj.class
        obj.bind(self)
      elsif obj.is_a? Proc
        obj
      else
        raise(TypeError, "Can't apply #{obj}") unless obj.respond_to? :call
      end
    end

    def mapply(sym)
      ->(*as) { 
        as.map! {|c| eval *c}
        as.first.send(sym, *as.drop(1))
      }
    end
  end
end

