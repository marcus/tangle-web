Nodes.namespace "Nodes.App"

Nodes.App = Backbone.View.extend(
  initialize: ->
    @assignElements()
    @addPrimaryNode new Nodes.Models.Node @options.primaryNode

  addPrimaryNode: (m)->
    v = new Nodes.NodeView(model: m)
    console.log @primaryNodeEl
    @primaryNodeEl.html v.render().el

  assignElements: ->
    @parentNodesEl = @$('#parent_nodes')
    @primaryNodeEl = @$('#primary_node')
    @siblingNodesEl = @$('#sibling_nodes')
    @childrenNodesEl = @$('#children_nodes')
    @notesEl = @$('#notes')

)

#######

jQuery(document).ready( ->
  Nodes.nodeApp = new Nodes.App({primaryNode: primaryNode, el: $('#nodes_app')})
)
