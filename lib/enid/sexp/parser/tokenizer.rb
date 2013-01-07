module Enid
  class Sexp::Parser
    class Tokenizer
      WHITESPACE = /[\s\n\r\t]/
      attr_reader :tokens
      def initialize(str)
        @chars, @current, @tokens = str.chars, '', []
        tokenize
      rescue StopIteration
        append_current
      end

      private
      def tokenize
        while char = @chars.next
          if char == ?"
            append_current
            read_string
          elsif char =~ WHITESPACE
            append_current
          elsif @current.empty? && (char =~ /[0-9]/ || char =~ /[+-]/ && @chars.peek =~ /[0-9]/)
            read_numeric(char)
          elsif @current.empty? && char =~ /[A-Z]/
            read_constant(char)
          elsif tok = Token.ize(char)
            append_current
            append tok
          else
            @current << char
          end
        end
      end

      def append_current
        (@tokens << Token.new(@current)) unless @current.empty?
        @current.clear
      end

      def append(token)
        @tokens << token
      end

      def read_string
        s=''
        until (char=@chars.next) == ?"
          s << char
        end
        append Token::String.new(s)
      end

      def read_numeric(c)
        n = c.dup
        while (@chars.peek) =~ /[0-9.]/
          n << @chars.next
        end
        append Token::Numeric.new eval n
      end

      def read_constant(c)
        s = c.dup
        while @chars.peek =~ /[A-Za-z0-9:_]/
          s << @chars.next
        end
        append Token::Constant.new s
      end

    end
  end
end

