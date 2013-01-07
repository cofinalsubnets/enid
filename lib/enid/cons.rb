module Enid
  class Cons
    require 'enid/cons/extensions'
    VERSION = '0.0.0'

    class << self
      def cons(car, cdr)
        Cons.new car, cdr
      end
      alias [] cons

      def list(*elts)
        head = cons elts.shift, nil
        elts.reduce(head) do |tail, elt|
          tail.rplacd(cons elt, nil).cdr
        end
        head
      end

      def parse(s)
        Sexp.new(s).cons
      end
    end

    include Enumerable
    attr_reader :car, :cdr

    def rplaca(a)
      @car = a
      self
    end

    def rplacd(d)
      @cdr = d
      self
    end

    def nconc(v)
      last.rplacd v
      self
    end 

    def length
      to_a.length
    end

    def last(n = 1)
      (1..(length - n)).reduce(self) {|cons| cons.cdr}
    end

    def append(*conses)
      conses.any?? dup.nconc(conses.shift.append *conses) : rdup
    end

    def initialize(car, cdr)
      @car, @cdr = car, cdr
    end

    def each_cons(&blk)
      enum = Enumerator.new do |y|
        y << self
        cdr.each_cons {|c| y<<c} if cdr.is_a? Cons
      end
      block_given?? enum.each {|c| yield c} : enum
    end

    def each
      enum = Enumerator.new do |y|
        each_cons {|cons| y << cons.car}
      end
      block_given? ? enum.each {|n| yield n} : enum
    end

    def method_missing(mtd, *args)
      mtd.to_s.match(/c([ad]+)r/) ? _c_r($1) : super
    end

    def proper?
      last(0).nil?
    end

    def empty?
      car.nil? and cdr.nil?
    end

    def to_a
      empty?? [] : super
    end

    def dup
      Cons.list *to_a
    end

    def to_s
      Sexp.new(self).to_s
    end

    def ==(c)
      c.is_a?(Cons) && c.to_a == to_a
    end

    def [](n)
      to_a[n]
    end

    def map
      self.class.list *super
    end

    def []=(n,val)
      (1..n).reduce(self) {|c| c.cdr}.rplaca val
      val
    end
    private

    def _c_r(c_r)
      c_r.reverse.each_char.reduce(self) {|cons, cell| cons.send "c#{cell}r"}
    end

  end
end

