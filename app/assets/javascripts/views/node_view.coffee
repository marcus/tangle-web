Nodes.NodeView = Backbone.View.extend(
  initialize: ->
    @controller = @options.controller
    @template = JST['templates/node']
    @model.on 'change', => @render() # TODO - use bindings

  render: ->
    values = @model.attributes
    @$el.html @template(values)
    @renderChildren() if @options.renderChildren
    this

  events: ->
    'click'        :     'focus'
    'click .uuid'  : 'ignore'

  focus: ->
    @controller.focusNode @model

  ignore: -> false

  renderChildren: ->
    @controller.findAndRenderChildren(@model, renderContainer: @$('.children'), ignoreFocused: true)

)
