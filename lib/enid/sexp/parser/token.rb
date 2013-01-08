module Enid
  class Sexp::Parser
    class Token
      attr_reader :value
      def initialize(v)
        @value = v.to_sym
      end

      def to_s
        value.inspect
      end

      class String < Token
        def initialize(s)
          @value = s.to_s
        end
      end

      class Numeric < Token
        def initialize(n)
          @value = n
        end
      end

      class Constant < Token
        def initialize(n)
          @value = n.split('::').reduce(Object) {|c,n| c.const_get n}
        end
      end

      SPECIAL = [ 
        OPEN  = new(?(),
        CLOSE = new(?)),
        EXPQT = new(?'),
        MCRQT = new(?`),
        MCRSP = new(?,)
      ]

      def self.ize(char)
        SPECIAL.select {|t| t.value == char.to_sym}.first
      end

    end
  end
end

