module DecisionGraph
  class Node
    attr_reader :name
    def initialize(name, options = {})
      @name = name
    end

    def explanatory text=nil
      return @explanatory if text.nil?
      @explanatory = text
    end
  end
end