@tangle.controller 'NodesCtrl', ['$scope', '$routeParams', '$location', 'nodeResource', 'nodeCache', 'NodeModel',
($scope, $routeParams, $location, nodeResource, nodeCache, NodeModel) ->
  cacheQueue = []
  groups = ['childNodes', 'companionNodes', 'parentNodes', 'siblingNodes']

  $scope.resetGroups = -> _.each groups, (p) -> $scope[p] = {}

  $scope.showPrimary = (node) ->
    $scope.resetGroups()
    nodeCache.put(node.uuid, node) if !nodeCache.get node.uuid
    $scope.primaryNode = node
    $scope.showRelationships(node)

  $scope.updatePrimary = (nodeId) ->
    $location.url "/nodes/#{nodeId}"
    $scope.fetchOne(nodeId)

  # Fetchers
  $scope.fetchOne = (nodeId) ->
    NodeModel.get node_id: nodeId,
      ((resource) -> $scope.showPrimary(resource)),
      ((response) -> $scope.error response)

  $scope.fetchList = (nodeIds) ->
    NodeModel.query ids: nodeIds.join(","),
      ((response) -> $scope.indexFetched(response)),
      ((response) -> $scope.error response)

  $scope.indexFetched = (nodes) ->
    console.log "Response", nodes
    _.each nodes, (n) -> nodeCache.put(n.uuid, n)
    $scope.updateGroupsFromCache()

  $scope.showRelationships = (node) ->
    # Display the nodes we have and queue the rest
    $scope.childNodes = $scope.tryNodes(node.child_uuids)
    $scope.companionNodes = $scope.tryNodes(node.companion_uuids)
    $scope.parentNodes = $scope.tryNodes(node.parent_uuids)
    $scope.siblingNodes = $scope.tryNodes(node.sibling_uuids)
    # Now that child, parent, companion nodes are queued, fetch it
    $scope.fetchList(cacheQueue) if cacheQueue.length > 0
    cacheQueue = []

  $scope.tryNodes = (nodeUuids) ->
    result = {}
    _.each nodeUuids, (u) -> result[u] = tryNodeCache(u)
    result

  tryNodeCache = (u) ->
    unless nodeCache.get u
      cacheQueue.push u
      nodeCache.put(u, {title: "Loading...", uuid: u})
    nodeCache.get u

  $scope.updateGroupsFromCache = ->
    _.each groups, (p) ->
      _.each $scope[p], (n) ->
        $scope[p][n.uuid] = nodeCache.get n.uuid

  $scope.error = (response) ->
    console.log "Error", response
    $scope.errorText = "Something went wrong #{response.status}"

  if $routeParams.id
    $scope.fetchOne($routeParams.id)
  else
    $scope.showPrimary(window.primaryNode)
]
