module DecisionTree
  ##
  # A decision tree which can manage its own current state based on
  # answers it is given
  class Tree < Node
    attr_reader :current_node

    def initialize(name, options = {})
      super(name, options)
      @nodes = {}
      @start_node = @current_node = nil
    end

    def start_node
      @start_node
    end

    def [] name
      name = name.gsub('-', '_').to_sym if name.is_a?(String)
      @nodes[name] || @nodes[(name.to_s + '?').to_sym]
    end

    def []= name, value
      @start_node = @current_node = value if @nodes.empty?
      @nodes[name] = value
    end

    def set_state(name)
      @current_node = self[name]
    end

    ##
    # Move on to another (valid) node
    def provide_answer(name)
      name = name.gsub('-', '_').downcase if name.is_a?(String)
      next_node = self[current_node.answers[name.to_sym]]
      raise ArgumentError, "No answer with name #{name} from #{current_node.name}" if next_node.nil?
      @current_node = next_node
    end
  end
end
