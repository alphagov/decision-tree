require 'active_support/inflector'

module DecisionTree
  class Node
    attr_reader :name
    def initialize(name, options = {})
      @name = name
      set_copy
    end

    def set_copy
      name_str = @name.to_s
      key_base = name_str[-1] == '?' ? name_str[0..-2] : name_str
      @display_name = I18n.t(key_base + '.display_name', :default => ActiveSupport::Inflector.humanize(@name))
      @explanatory = I18n.t(key_base + '.explanatory', :default => '')
      @explanatory = nil if @explanatory == ''
    end

    def explanatory text=nil
      return @explanatory if text.nil?
      @explanatory = text
    end

    def display_name text=nil
      return @display_name if text.nil?
      @display_name = text
    end
    
    def tags text=nil
      return @tags if text.nil?
      @tags = text
    end
  end
end