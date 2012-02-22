Nodes.NodeView = Backbone.View.extend(
  initialize: ->
    @controller = @options.controller
    @template = JST['templates/node']
    @model.on 'change', => @render() # TODO - use bindings

  render: ->
    values = @model.attributes
    @$el.html @template(values)
    this

  events: ->
    'click'        :     'focus'
    'click .uuid'  : 'ignore'

  focus: ->
    @controller.focusNode @model

  ignore: -> false

)
