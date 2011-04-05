module DecisionGraph
  class Graph
    attr_reader :name, :current_node
    attr_accessor :display_name

    def initialize(name)
      @name = name
      @nodes = {}
      @start_node = nil
      @current_node = nil
    end

    def start_node
      @start_node
    end

    def [] name
      @nodes[name]
    end

    def []= name, value
      @start_node = @current_node = value if @nodes.empty?
      @nodes[name] = value
    end

    def answer name
      next_node = self[current_node.answers[name]]
      raise ArgumentError, "No answer with name #{name} from #{current_node.name}" if next_node.nil?
      @current_node = next_node
    end
  end
end
