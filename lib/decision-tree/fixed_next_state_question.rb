module DecisionTree
  ##
  # A question which always leads on to the same next question
  # (but can add something to the state which may matter later)
  class FixedNextStateQuestion < Question
    attr_reader :type, :next_question
    def initialize(name, next_question, options = {})
      super(name, options)
      @next_question = next_question
    end

    def answer name, options = {}
      # All answers point to the fixed next question
      @answers[name] = @next_question
      # What to do with :advisory_copy?
      advisory_copy_sym = options.delete(:advisory_copy)

    end
  end
end