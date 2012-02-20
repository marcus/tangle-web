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
    @clearExistingNodes()
    @findAndRenderParents(m)
    @findAndRenderSiblings(m)
    @findAndRenderChildren(m)
    @notesEl.html(m.get('description')) # TODO - create a new view for this

  getNodeView: (m) ->
    nv = new Nodes.NodeView(model: m, controller: this) # TODO - search the cache

  # TODO - DRY
  addParentNode: (m) ->
    @parentNodesEl.append @getNodeView(m).render().el

  addChildNode: (m) ->
    @childrenNodesEl.append @getNodeView(m).render().el

  addSiblingNode: (m) ->
    @siblingNodesEl.append @getNodeView(m).render().el

  findAndRenderParents: (m) ->
    _.each m.get('parent_uuids'), (uuid) => @addParentNode @collection.try(uuid)

  findAndRenderSiblings: (m) ->
    _.each m.get('sibling_uuids'), (uuid) => @addSiblingNode @collection.try(uuid)

  findAndRenderChildren: (m) ->
    _.each m.get('child_uuids'), (uuid) => @addChildNode @collection.try(uuid)

  clearExistingNodes: ->
    _.each [@parentNodesEl, @childrenNodesEl, @siblingNodesEl, @notesEl], (n) -> n.html('')

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
