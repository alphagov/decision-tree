require 'active_support/core_ext/hash/slice'

module DecisionTree
  class Builder
    def initialize(name)
      @tree = Tree.new(name)
    end

    def build
      @tree
    end

    def display_name(text)
      @tree.display_name = text
    end

    def question(name_or_hash, options = {}, &block)
      if name_or_hash.is_a? Hash
        # A hash means this is a question which always goes to a next state (and the options are in the same hash)
        name = name_or_hash.keys.first
        next_question = name_or_hash[name]
        question = FixedNextStateQuestion.new(name, next_question, name_or_hash.slice(:type))
      else
        name = name_or_hash
        question = Question.new(name_or_hash, options)
      end
      @tree[name] = question
      question.instance_eval(&block)
      question
    end

    def outcome(name, options = {}, &block)
      outcome = Outcome.new(name, options)
      @tree[name] = outcome
      outcome.instance_eval(&block) if block
      outcome
    end
  end
end