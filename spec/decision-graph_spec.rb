require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DecisionGraph::Graph do
  describe "A DSL to create a graph" do
    # Note: not the real or even vaguely accurate graph, just a subset for testing
    subject do
      decision_graph :should_i_register_for_vat? do
        display_name "Should I register for VAT?"

        question :are_you_in_business? do
          answer :no => :you_cannot_register_for_vat
          answer :yes => :are_you_based_in_the_uk?
        end

        question :are_you_based_in_the_uk? do
          explanatory "England, Scotland, Wales, NI"
          answer :yes => :what_is_your_turnover?
          answer :no => :you_should_register_as_a_non_established_taxable_person
        end

        question :does_your_business_operate_in_any_of_these_sectors? => :what_is_your_turnover? do
          answer "Agriculture, horticulture or fisheries"
          answer :barristers_and_advocates, :accretes => :barrister_advice
          answer :racehorse_owners, :accretes => :racehorse_advice
          answer :retail_sector, :accretes => :retail_advice
          answer :none_of_the_above_apply
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

    describe "After creation" do
      describe "the graph" do
        specify { subject.name.should == :should_i_register_for_vat? }
        specify { subject.display_name.should == "Should I register for VAT?" }
      end

      describe "The first question" do
        let(:first_question) { subject.start_node }
        specify { first_question.should be_a(DecisionGraph::Question) }
        specify { first_question.should have(2).answers }
        specify { first_question.answers.should include(:no) }
        specify { first_question.answers[:no].should == :you_cannot_register_for_vat }
        specify { first_question.name.should == :are_you_in_business? }
        specify { first_question.display_name.should == "Are you in business?" }
      end

      specify { subject[:you_must_register_for_vat].should be_a(DecisionGraph::Outcome) }
      specify { subject[:you_can_register_for_vat].explanatory.should == "It's possible" }
      specify { subject[:are_you_based_in_the_uk?].explanatory.should == "England, Scotland, Wales, NI" }

      specify { subject.current_node.should == subject.start_node }
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