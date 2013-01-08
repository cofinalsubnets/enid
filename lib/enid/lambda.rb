module Enid
  class Lambda < Struct.new(:list, :body)
    autoload :List, 'enid/lambda/list'

    def initialize(params, body=nil)
      self.list, self.body = List.new(params), body
    end

    def bind(context)
      @context = context
      self
    end

    def call(*args)
      raise "Can't call an unbound Lambda" unless @context
      args.map! {|a| @context.eval a}
      @context.eval [:let, list.bind(args), *body]
    end

    def bound?
      !!@context
    end
  end
end

