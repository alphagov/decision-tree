module DecisionTree
  class Builder
    def initialize(name)
      @graph = Tree.new(name)
    end

    def build
      @graph
    end

    def display_name(text)
      @graph.display_name = text
    end

    def question(name, options = {}, &block)
      question = Question.new(name, options)
      @graph[name] = question
      question.instance_eval(&block)
      question
    end

    def outcome(name, options = {}, &block)
      outcome = Outcome.new(name, options)
      @graph[name] = outcome
      outcome.instance_eval(&block) if block
      outcome
    end
  end
end