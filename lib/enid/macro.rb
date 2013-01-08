module Enid
  class Macro < Lambda
    def call(*args)
      raise "Can't call an unbound Macro" unless @context
      @context.eval [:let, list.bind(args), *body]
    end
  end
end

