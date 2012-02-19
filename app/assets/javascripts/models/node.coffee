Nodes.namespace "Nodes.Models.Node"

Nodes.Models.Node = Backbone.Model.extend(
  idAttribute: "uuid"

  url: ->
    if @isNew()
      '/nodes.json'
    else
      'nodes/' + @attributes('guid') + '.json'

)
