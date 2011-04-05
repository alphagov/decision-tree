module DecisionGraph
  class Question < Node
    attr_reader :answers

    def initialize(name, options = {})
      super
      @answers = {}
    end

    def answer main_arg, options = {}
      if main_arg.is_a? Hash
        main_arg.each_pair {|answer, next_node| @answers[answer] = next_node}
      else

      end
    end
  end
end