require 'spec_helper'

describe Cons::Sexp do
  let(:list) { Cons.list 1,2,3,4,5 }
  let(:dotted_list) { list.nconc 6 }
  let(:nested_list) do
    Cons.list ?a, ?b, Cons.list(?c, ?d), Cons.list( Cons.list ?e)
  end

  describe 'for a proper list' do
    subject { Cons::Sexp.new(list) }
    it { should == '(1 2 3 4 5)' }
  end

  describe 'for a dotted list' do
    subject { Cons::Sexp.new(dotted_list) }
    it { should == '(1 2 3 4 5 . 6)' }
  end

  describe 'for a nested list' do
    subject { Cons::Sexp.new(nested_list) }
    it { should == '(a b (c d) ((e)))' }
  end

end

