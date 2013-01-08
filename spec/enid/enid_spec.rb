require 'spec_helper'

describe Enid do
  specify { enid_eval("(+ 1 2)").should == 3 }
  specify { enid_eval("(def add (fn (a b) (+ a b)))", "(add 1 2)").should == 3 }
  specify { enid_eval("(def num 45)", "num").should == 45 }
end

