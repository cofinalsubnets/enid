class NilClass
  def car; nil; end
  def cdr; nil; end
  def each; nil end
  include Enumerable
end

