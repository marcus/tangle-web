Nodes.NodeView = Backbone.View.extend(
  initialize: ->
    @template = JST['templates/node']

  render: ->
    values = @model.attributes
    console.log values
    @$el.html @template(values)
    this

)
