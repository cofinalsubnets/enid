module Enid
  class LambdaList < Cons
    def initialize(*names)
      @car = names.first
      @cdr = LambdaList.new(*names.drop(1)) unless names.drop(1).empty?
    end

    def apply(vals)
      pairs = to_a.zip(vals.to_a).map {|c| Cons.list *c}
      Cons.list *pairs
    end
  end
end

