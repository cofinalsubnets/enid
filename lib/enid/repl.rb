module Enid
  class Repl
    Stop = Class.new StandardError
    Value = Struct.new :value

    def initialize
      @scope = Scope.new quit: Func::Special.new {raise Stop}
      repl
    end

    private

    def repl
      loop do
        print "\n>> "
        begin 
          rep 
        rescue => e
          break if e.is_a? Stop
          puts "#{e.class}:#{e.message}\n  #{e.backtrace.take(10).join "\n  "}"
        end
      end
    end

    def rep
      print re
    end

    def re
      (v=r).is_a?(Value) ? v.value : @scope.eval(v)
    end

    def r
      line = gets.chomp
      if line =~ /^:r (.*)$/
        Value.new(eval $1)
      else
        Sexp.new(line).cons
      end
    end

  end
end

