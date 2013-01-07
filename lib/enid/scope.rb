module Enid
  class Scope
    attr_reader :bindings

    def initialize(binds = {})
      @bindings = Func::Global.bindings.merge(binds)
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

    def eval(form)
      if form.is_a?(Cons)
        case fn = resolve(form.car)
        when Func::Special
          call fn, form.cdr
        when Func, Proc
          call(fn, form.cdr.map {|e| eval(e)})
        end
      elsif form.is_a?(Symbol)
        @bindings.has_key?(form) ?
          @bindings[form] :
          raise(NameError, "Unable to resolve symbol `#{form}' in this context (#{depth} level(s) below toplevel)")
      else
        form
      end
    end

    def resolve(sym)
      cf = sym.to_s.downcase.to_sym
      if @bindings.has_key?(cf)
        @bindings[cf]
      else
        mapply sym
      end
    end

    def mapply(sym)
      ->(cons, context) do
        (a=cons.to_a).first.send(sym, *a.drop(1))
      end
    end

    def call(fn, *as)
      fn.call *as, self
    end
  end
end

