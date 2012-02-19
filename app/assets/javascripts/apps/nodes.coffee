Nodes.namespace "Nodes.App"

Nodes.App = Backbone.View.extend(
  initialize: ->
    @collection = new Nodes.NodesCollection()
    @assignElements()

    nodeOne = @addOne @options.primaryNode
    @focusNode nodeOne

  addOne: (node) ->
    node = new Nodes.Models.Node node, collection: @collection if !node.cid
    @collection.add(node)
    node

  focusNode: (m) ->
    nv = new Nodes.NodeView(model: m) # TODO - cache and Find views
    @primaryNodeEl.html nv.render().el
    @notesEl.html(m.get('description')) # TODO - create a new view for this
    @findAndRenderParents(m)
    @findAndRenderSiblings(m)
    @findAndRenderChildren(m)

  # TODO - obv this could all be consolidated
  addParentNode: (m) ->
    nv = new Nodes.NodeView(model: m) # TODO - search the cache
    @parentNodesEl.append nv.render().el

  addChildNode: (m) ->
    nv = new Nodes.NodeView(model: m) # TODO - search the cache
    @childrenNodesEl.append nv.render().el

  addSiblingNode: (m) ->
    nv = new Nodes.NodeView(model: m) # TODO - search the cache
    @siblingNodesEl.append nv.render().el

  findAndRenderParents: (m) ->
    _.each m.get('parent_uuids'), (uuid) => @addParentNode @collection.get(uuid)

  findAndRenderSiblings: (m) ->
    _.each m.get('sibling_uuids'), (uuid) => @addSiblingNode @collection.get(uuid)

  findAndRenderChildren: (m) ->
    _.each m.get('child_uuids'), (uuid) => @addChildNode @collection.get(uuid)

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
