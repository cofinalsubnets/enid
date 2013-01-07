module Enid
  class Sexp < String
    autoload :Parser, 'enid/sexp/parser'
    attr_reader :cons

    def initialize(val)
      case val
      when String
        @cons = Parser.new(val).cons
      when Cons
        @cons = val
      else
        raise TypeError, "Can't convert #{val} into s-expression"
      end
      super emit
    end

    private
    def emit
      "(#{
        @cons.each_cons.reduce('') do |s, c|
          s << " #{stringify c.car}"
          s << " . #{stringify c.cdr}" unless c.cdr.is_a?(Cons) || c.cdr.nil?
          s
        end.strip unless @cons.empty?
      })" if @cons
    end

    def stringify(val)
      val.is_a?(Symbol) ? val.to_s : val.inspect
    end
  end
end

