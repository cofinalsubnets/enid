module Enid
  class Sexp < String
    autoload :Parser, 'enid/sexp/parser'
    attr_reader :seq

    def initialize(val)
      case val
      when String
        @seq = Parser.new(val).seq
      when Enumerable
        @seq = val
      else
        raise TypeError, "Can't convert #{val} into s-expression"
      end
      super emit
    end

    private
    def emit(s = @seq)
      s.kind_of?(Enumerable) ? "(#{s.map {|q| stringify q}.join ' '})" : stringify(s)
    end

    def stringify(s)
      case s
      when Enumerable
        emit s
      when Symbol
        s.to_s
      else
        s.inspect
      end
    end
  end
end

