module Enid
  class Sexp
    class Parser
      require 'enid/sexp/parser/token'
      require 'enid/sexp/parser/tokenizer'
      ParseException = Class.new StandardError
      attr_reader :seq

      def initialize(sexp)
        @tokens = Tokenizer.new(sexp).tokens
        @tokens.size==1 ? (@seq=@tokens.first.value) : parse
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
          @stack << []
        when Token::CLOSE
          v = @stack.pop
          @seq = @stack.empty?? v : cur.push(v)
        else
          cur << token.value
        end
      end

      def cur
        @stack.last
      end

    end
  end
end

