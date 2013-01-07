module Enid
  class Func < Cons
    alias lambda_list car
    alias body cdr
    Special = Class.new(Proc)


    def initialize(car, cdr)
      raise(TypeError, "`#{car}' is not a lambda list") unless car.is_a? LambdaList
      raise(TypeError, "`#{cdr}' is not a cons") unless cdr.is_a? Cons
      super
    end

    def call(args, context)
      args = Cons.list if args.nil?
      raise(TypeError, "`#{args}' is not a cons") unless args.is_a? Cons
      context.eval(Cons[:let, Cons[lambda_list.apply(args), body]])
    end


    module Global
      def self.bindings
        Hash[ constants.map {|c| [c.to_s.downcase.to_sym, const_get(c)]} ]
      end

      DEFUN = Special.new do |cons, context|
        name, binds, body = cons.car, cons.cadr, cons.cddr
        context.bindings[name] = Func.new(LambdaList.new(*binds), body)
      end

      LET = Special.new do |cons, context|
        defs, body = cons.car, cons.cdr
        defs.to_a.reduce(context) do |scope, binding|
          val = scope.eval(binding.cadr)
          scope.new binding.car => val
        end.eval(Cons[:prog, body])
      end

      PROG = Special.new do |form, context|
        form.to_a.map {|form| context.eval(form)}.last
      end
    end

  end
end

