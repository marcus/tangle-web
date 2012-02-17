Nodes.NodeView = Backbone.View.extend(
  initialize: ->
    @template = JST['templates/node']

  render: ->
    values = @model.attributes
    @$el.html @template(values)
    this

)
