require 'decision-tree/node'
require 'decision-tree/tree'
require 'decision-tree/question'
require 'decision-tree/outcome'
require 'decision-tree/builder'

def decision_graph(name, &block)
  builder = DecisionTree::Builder.new(name)
  builder.instance_eval(&block)
  builder.build
end