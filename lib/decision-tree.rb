require 'decision-tree/node'
require 'decision-tree/tree'
require 'decision-tree/question'
require 'decision-tree/fixed_next_state_question'
require 'decision-tree/outcome'
require 'decision-tree/builder'

require 'decision-tree/dot_renderer'

def decision_tree(name, &block)
  builder = DecisionTree::Builder.new(name)
  builder.instance_eval(&block)
  builder.build
end