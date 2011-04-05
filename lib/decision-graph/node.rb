require 'active_support/inflector'

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

    def display_name text=nil
      return (@display_name || ActiveSupport::Inflector.humanize(@name)) if text.nil?
      @display_name = text
    end
  end
end