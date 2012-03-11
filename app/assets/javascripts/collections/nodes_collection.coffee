Nodes.namespace "Nodes.NodesCollection"

Nodes.NodesCollection = Backbone.Collection.extend(
  add: (models, options) ->
    Backbone.Collection.prototype.add.call(this, models, options) # super
    models = if _.isArray(models) then models.slice() else [models]
    _.each models, (m) => @getModelsFromRelationships(m)

  getModelsFromRelationships: (m) ->
    _.each ['children', 'parents', 'companions'], (relation) =>
      _.each m.get(relation), (nodeJson) => @add new Nodes.Models.Node nodeJson

  # Look for it, if we don't have it, return a shim then make the request in
  # the background and fill it in
  try: (id) ->
    if model = @get id
      model
    else
      wanted = new Nodes.Models.Node(uuid: id, title: "Loading...")
      @add(wanted)
      @queueFetch(wanted)
      wanted

  fetchQueue: []

  queueFetch: (wanted) ->
    clearTimeout(@timeout) if @timeout
    @fetchQueue.push(wanted)
    @timeout = setTimeout( =>
      @fetchAll()
    , 250)

  fetchAll: ->
    return @fetchQueue[0].fetch if @fetchQueue.length == 0
    @fetchMultiple(@fetchQueue)
    @fetchQueue = []

  fetchMultiple: (models) ->
    $.get('/nodes.json', ids: _.map(@fetchQueue, (m) -> m.id).join(","), (response) => @fetchedMultiple(response))

  fetchedMultiple: (response) ->
    _.each(response, (n) =>
      model = @get(n.uuid)
      model.set(model.parse(n))
    )
)
