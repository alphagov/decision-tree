require 'spec_helper'
require 'decision-tree'

describe "Rendering a graph" do
  let :tree do
    decision_tree :should_i_register_for_vat? do
      display_name "Should I register for VAT?"

      question :are_you_in_business? do
        answer :no => :you_cannot_register_for_vat
        answer :yes => :are_you_based_in_the_uk?
      end

      question :are_you_based_in_the_uk? do
        answer :yes => :undefined_will_appear_as_ellipse
        answer :no => :you_should_register_as_a_non_established_taxable_person
      end

      outcome :you_cannot_register_for_vat
      outcome :you_should_register_as_a_non_established_taxable_person do
        display_name "You should register as a non-established taxable person"
      end
    end
  end

  let :rendered do
    DecisionTree.render_dot(tree)
  end

  after :all do
    File.open('tree_spec.dot', 'w') do |f|
      f.write(rendered)
      f.close
    end
    puts rendered
  end

  it "should be a digraph with a title" do
    rendered.should =~ /^digraph\s*".*"\s{/
  end

  it "should have all nodes with question marks removed" do
    tree.nodes.each_pair do |name, node|
      rendered.should include("#{name.to_s.chomp('?')}")
    end
  end

  it "should render nodes as records" do
    rendered.should =~ /.*\[.*shape=record/
  end

  it "renders nodes with explanatories in { two | segments }" do
    pending "Deal with multi-line markdown"
    rendered.should =~ /are_you_based_in_the_uk .*label="\{ Are you based.*\| England, Scotland.*\}"/
  end

  it "should connect the boxes with answers (no '?')" do
    rendered.should include('are_you_in_business -> are_you_based_in_the_uk [label="Yes"]')
  end

  describe "Attributes" do
    specify { DecisionTree.render_attrs({'shape' => 'box', 'label' => 'Hi'}).should == '[shape=box,label="Hi"]'}
  end
end

