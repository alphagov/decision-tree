#require 'active_support'

require 'decision-graph/node'
require 'decision-graph/graph'
require 'decision-graph/edge'
require 'decision-graph/question'
require 'decision-graph/outcome'
require 'decision-graph/builder'

def decision_graph(name, &block)
  builder = DecisionGraph::Builder.new(name)
  builder.instance_eval(&block)
  builder.build
end