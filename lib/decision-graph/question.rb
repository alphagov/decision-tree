module DecisionGraph
  class Question < Node
    attr_reader :answers

    def initialize(name, options = {})
      super
      @answers = {}
    end

    def answer hash
      hash.each_pair {|answer, next_node| @answers[answer] = next_node}
    end
  end
end