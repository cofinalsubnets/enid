module Enid
  class Lib < Module
    def included(scope)
      instance_methods.each do |mtd|
        scope.bindings[mtd] = scope.instance_method(mtd)
      end
    end

    def initialize(name=nil, &b)
      super(&b)
      Enid::Lib.const_set(name, self) if name
    end
  end

  Lib.new :Std do
    def eval(v)
      if v.is_a?(Array) and !v.empty?
        resolve(v.first).call *v.drop(1)
      elsif v.is_a? Symbol
        @bindings.has_key?(v) ?
          @bindings[v] :
          raise(NameError, "Unable to resolve symbol `#{v}' in this context (#{depth} level(s) below toplevel)")
      else
        v
      end
    end

    def def(name, val)
      bindings[name] = eval(val)
    end

    def fn(params, *body)
      Lambda.new(params, body)
    end

    def let(binds, *body)
      new(Hash[binds]).eval [:prog, *body]
    end

    def prog(*body)
      body.map {|form| eval(form)}.last
    end

    def _eval(string)
      eval Sexp.new(string).seq
    end
  end
end

