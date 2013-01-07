require 'spec_helper'

describe Cons do
  let(:list) { Cons.list 1,2,3,4,5}
  let(:cons) { Cons[1,2] }

  describe '::cons' do
    specify { ->{Cons.cons 1}.should raise_error ArgumentError }
    subject { Cons.cons 1, 2 }
    it { should be_an_instance_of Cons }
    it { should_not be_proper }
    its(:car) { should be 1 }
    its(:cdr) { should be 2 }
  end

  describe '::list' do
    shared_examples_for 'a proper list' do
      it { should be_an_instance_of Cons }
      it { should be_proper }
    end

    let(:list) { Cons.list 1,2,3,4}
    describe 'a singleton list' do
      subject { Cons.list 1 }
      it_behaves_like 'a proper list'
      its(:car) { should be 1 }
      its(:cdr) { should be_nil }
    end

    describe 'an empty list' do
      subject { Cons.list }
      it_behaves_like 'a proper list'
    end

    describe 'a list with multiple elements' do
      subject { Cons.list 1,2,3,4 }
      it { should have(4).things }
      its(:car) { should be 1 }
      its(:cdr) { should == Cons.list(2,3,4) }
    end
  end

  describe '#each' do
    it 'should yield itself and each successive cons' do
      list = Cons.list 1,2,3,4,5
      list.each.to_a.should == [list, list.cdr, list.cddr, list.cdddr, list.cddddr]
    end
  end

  describe '#last' do
    let(:list) { Cons.list 1,2,3,4,5 }
    context 'with no arguments' do
      it 'returns the last cons in the list' do
        list.last.should == Cons.list(5)
      end
    end

    context 'with a positive integer argument n' do
      it 'returns the tail with n arguments' do
        list.last(3).should == Cons.list(3,4,5)
      end
    end
    context 'with zero as the argument' do
      it 'returns the cdr of the last cons' do
        list.last(0).should be_nil
      end
    end
  end

  describe '#to_a' do
    specify { list.to_a.should == [1,2,3,4,5] }
  end

  describe '#rplaca' do
    it 'sets the car of the receiver to the argument' do
      cons.rplaca(2)
      cons.should == Cons[2,2]
    end
    it 'returns the receiver' do
      cons.rplaca(2).should == Cons[2,2]
    end
  end

  describe '#rplacd' do
    it 'sets the cdr of the receiver to the argument' do
      cons.rplacd(1)
      cons.should == Cons[1,1]
    end
    it 'returns the receiver' do
      cons.rplacd(1).should == Cons[1,1]
    end
  end

  describe '#method_missing' do
    let(:list) { Cons.list(1, Cons.list( Cons.list(2,3,4), 5), 6 ) }
    it 'handles messages matching /c[ad]+r/' do
      list.cadaadr.should == 3
    end
  end

  describe '#proper?' do
    it 'returns true if and only if the cdr of the last cons in the list is nil' do
      list.should be_proper
      cons.should_not be_proper
    end
  end

  describe '#nconc' do
    it 'replaces the cdr of the last cons in the list with its argument' do
      list.nconc(Cons.list 6,7,8).should == Cons.list(1,2,3,4,5,6,7,8)
    end
  end

  describe '#[]=' do
    context 'when called with an index n and a value v' do
      it 'replaces the car of the nth cons with v' do
        list[1]=3
        list.should == Cons.list(1,3,3,4,5)
      end
    end
  end

  describe '#[]' do
    context 'when called with an index n' do
      it 'returns the car of the nth cons' do
        list[3].should == 4
      end
    end
  end
end

