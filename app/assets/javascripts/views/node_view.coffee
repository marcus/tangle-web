Nodes.NodeView = Backbone.View.extend(
  initialize: ->
    @controller = @options.controller
    @template = JST['templates/node']

  render: ->
    values = @model.attributes
    @$el.html @template(values)
    this

  events: ->
    'click'  :     'focus'

  focus: ->
    @controller.focusNode @model


)
