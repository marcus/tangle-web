Nodes.namespace "Nodes.App"

Nodes.App = Backbone.View.extend(
  collection: {}

  initialize: (options) ->
    @collection = options.nodesCollection
    @addAll(options.initialNodes)

  addAll: (nodes) ->
    _.each nodes, (n) =>
      @collection.add new Nodes.Models.Node(n)

)

#######

jQuery(document).ready( ->
  Nodes.nodesCollection = new Nodes.Collections.NodesCollection
  Nodes.nodeApp = new Nodes.App({initialNodes: initialNodes, nodesCollection: Nodes.nodesCollection})
)
