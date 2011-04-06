require 'spec_helper'
require 'decision-tree'

describe DecisionTree::Tree do
  describe "A DSL to create a tree" do
    # Note: not the real or even vaguely accurate graph, just a subset for testing
    subject do
      decision_tree :should_i_register_for_vat? do
        display_name "Should I register for VAT?"

        question :are_you_in_business? do
          answer :no => :you_cannot_register_for_vat
          answer :yes => :are_you_based_in_the_uk?
        end

        question :are_you_based_in_the_uk? do
          answer :yes => :what_is_your_turnover?
          answer :no => :you_should_register_as_a_non_established_taxable_person
        end

        # Example of a copy-only question - makes no difference to the outcome but adds some
        # advisory blurbs if anything checked
        question :does_your_business_operate_in_any_of_these_sectors? => :what_is_your_turnover?,
                 :type => :checkbox do
          answer :agriculture_horticulture_fisheries, :advisory_copy => :agriculture_horticulture_fisheries_advice
          answer :barristers_and_advocates, :advisory_copy => :barrister_advice
          answer :racehorse_owners, :advisory_copy => :racehorse_advice
          answer :retail_sector, :advisory_copy => :retail_advice
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
        specify { first_question.should be_a(DecisionTree::Question) }
        specify { first_question.should have(2).answers }
        specify { first_question.answers.should include(:no) }
        specify { first_question.answers[:no].should == :you_cannot_register_for_vat }
        specify { first_question.name.should == :are_you_in_business? }

        it "should default the display name to the humanized version by default" do
          first_question.display_name.should == "Are you in business?"
        end
      end

      describe "Fixed next state questions" do
        let(:fixed_state_question) { subject[:does_your_business_operate_in_any_of_these_sectors?] }
        specify { fixed_state_question.should be_a(DecisionTree::FixedNextStateQuestion) }
        specify { fixed_state_question.type.should == :checkbox }
        specify { fixed_state_question.next_question.should == :what_is_your_turnover? }
      end

      specify { subject[:you_must_register_for_vat].should be_a(DecisionTree::Outcome) }
      specify { subject[:you_can_register_for_vat].explanatory.should == "It's possible" }
      specify { subject[:are_you_based_in_the_uk?].explanatory.should == "England, Scotland, Wales, NI" }

      specify { subject.current_node.should == subject.start_node }
    end

    describe "Copy settings" do
      it "should pull copy from i18n first, by default" do
        subject[:are_you_based_in_the_uk?].display_name.should == "Are you based in the United Kingdom?"
      end

      it "should pick up named copy settings from answer ... :advisory_copy => :copy_id" do
        answer_sym = subject[:does_your_business_operate_in_any_of_these_sectors?].answers[:barristers_and_advocates]
        subject[answer_sym].advisory_copy.should == "Advice for barristers"
      end
    end

    describe "answering questions in the graph" do
      it "should fail if responding with a choice that doesn't exist" do
        lambda { subject.provide_answer :foo }.should raise_error(ArgumentError)
      end

      it "should move to the next node" do
        subject.provide_answer(:no)
        subject.current_node.name.should == :you_cannot_register_for_vat
      end
    end
  end
end