module DecisionTree
  class Question < Node
    attr_reader :answers

    def initialize(name, options = {})
      super
      @answers = {}
      @type = options.delete(:type)
    end

    def answer(hash, options = {})
      hash.each_pair { |answer, next_node| @answers[answer] = next_node }
    end
  end
end