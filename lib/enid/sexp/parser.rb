module Enid
  class Sexp
    class Parser
      require 'enid/sexp/parser/token'
      require 'enid/sexp/parser/tokenizer'
      ParseException = Class.new StandardError
      attr_reader :cons

      def initialize(sexp)
        @tokens = Tokenizer.new(sexp).tokens
        parse
      end

      private
      def parse
        @toks, @stack = @tokens.each, []
        while tok = @toks.next
          handle tok
        end
      rescue StopIteration
        raise(ParseException, "Unexpected end of stream") unless @stack.empty?
      end


      def handle(token)
        case token
        when Token::OPEN
          list(cons = Cons.list)
          @stack << cons
        when Token::CLOSE
          @cons = @stack.pop
        when Token::DOT
          @dot = true
        else
          list token.value
        end
      end

      def cur
        @stack.last
      end

      def list(v)
        return unless cur
        if @dot
          cur.nconc(v)
          @dot = false
        else
          cur.car ? cur.nconc(Cons.list v) : cur.rplaca(v)
        end
      end
    end
  end
end

