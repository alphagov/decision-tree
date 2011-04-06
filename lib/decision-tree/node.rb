require 'active_support/inflector'

module DecisionTree
  class Node
    attr_reader :name
    def initialize(name, options = {})
      @name = name
      set_copy
    end

    def set_copy
      key_base = @name.to_s[0..-2]
      @display_name = I18n.t(key_base + '.display_name', :default => ActiveSupport::Inflector.humanize(@name))
      @explanatory = I18n.t(key_base + '.explanatory', :default => nil)
    end

    def explanatory text=nil
      return @explanatory if text.nil?
      @explanatory = text
    end

    def display_name text=nil
      return @display_name if text.nil?
      @display_name = text
    end
  end
end