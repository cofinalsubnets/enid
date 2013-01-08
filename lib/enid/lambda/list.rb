module Enid
  module Data
    class Lambda::List < Array
      def initialize(params)
        typify params
        freeze
      end

      def typify(params)
        params.each_with_index do |param, i|
          if param == :'*'
            unless params.last == params[i+1]
              raise ArgumentError, "Can't establish parameters after a rest parameter"
            end
            push [:rest, params[i+1]]
            break
          elsif param.is_a? Symbol
            push [:req, param]
          elsif param.is_a? Array
            push [:opt, *param]
          else
            raise ArgumentError, "`#{param}' is not a valid parameter"
          end
        end
      end

      def bind(vals)
        vals = vals.dup
        map { |param| send *param, vals }
      end

      def req(name, vals)
        if vals.empty?
          raise ArgumentError, "Required parameter `#{name}' not given" 
        end
        [name, vals.shift]
      end

      def opt(name, dflt, vals)
        [name, vals.empty? ? dflt : vals.shift]
      end

      def rest(name, vals)
        [name, vals]
      end
    end
  end
end

