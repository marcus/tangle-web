Nodes.namespace "Nodes.NodesCollection"

Nodes.NodesCollection = Backbone.Collection.extend(
  add: (models, options) ->
    Backbone.Collection.prototype.add.call(this, models, options) # super
    models = if _.isArray(models) then models.slice() else [models]
    _.each models, (m) =>
      _.each ['children', 'parents', 'siblings'], (relation) =>
        _.each m.get(relation), (nodeJson) => @add new Nodes.Models.Node nodeJson
)
