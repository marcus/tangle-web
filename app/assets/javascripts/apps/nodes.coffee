Nodes.namespace "Nodes.App"

Nodes.App = Backbone.View.extend(
  initialize: ->
    @assignElements()
    @focusNode new Nodes.Models.Node @options.primaryNode

  focusNode: (m)->
    pnv = new Nodes.NodeView(model: m) # Find views
    @primaryNodeEl.html pnv.render().el
    @findAndRenderChildren(m)

  findAndRenderChildren: (m) ->

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
