require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DecisionGraph::Graph do
  describe "A DSL to create a graph" do
    subject do
      decision_graph :should_i_register_for_vat? do
        question :are_you_in_business? do
          answer :no => :you_cannot_register_for_vat
          answer :yes => :what_type_of_business_are_you?
        end

        question :are_you_any_of_the_following_types_of_business? do
          explanatory "Limited company, sole trader etc"
          answer :yes => :are_you_based_in_the_uk?
          answer :no => :you_should_not_register_for_vat
        end

        question :are_you_based_in_the_uk? do
          answer :yes => :what_is_your_turnover?
          answer :no => :you_should_register_as_a_non_established_taxable_person
        end

        question :what_is_your_turnover? do
          answer :under_70k => :you_can_register_for_vat
          answer :over_70k => :you_must_register_for_vat
        end

        outcome :you_must_register_for_vat
        outcome :you_should_not_register_for_vat
        outcome :you_cannot_register_for_vat
        outcome :you_can_register_for_vat do
          explanatory "It's possible"
        end
        outcome :you_should_register_as_a_non_established_taxable_person
      end
    end

    describe "what the graph looks like after creation" do
      specify { subject.name.should == :should_i_register_for_vat? }

      specify { subject.start_node.should be_a(DecisionGraph::Question) }
      specify { subject.start_node.answers.should include(:no) }
      specify { subject.start_node.answers[:no].should == :you_cannot_register_for_vat }
      specify { subject.start_node.name.should == :are_you_in_business? }

      specify { subject[:you_must_register_for_vat].should be_a(DecisionGraph::Outcome) }
      specify { subject[:you_can_register_for_vat].explanatory.should == "It's possible" }
      specify { subject[:are_you_any_of_the_following_types_of_business?].explanatory.should == "Limited company, sole trader etc" }

      specify { subject.current_node.should == subject.start_node}
    end

    describe "answering questions in the graph" do
      it "should fail if responding with a choice that doesn't exist" do
        lambda { subject.answer :foo }.should raise_error(ArgumentError)
      end

      it "should move to the next node" do
        subject.answer(:no)
        subject.current_node.name.should == :you_cannot_register_for_vat
      end
    end
  end
end
