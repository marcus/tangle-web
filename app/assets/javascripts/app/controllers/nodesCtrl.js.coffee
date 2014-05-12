@tangle.controller 'NodesCtrl', ['$scope', '$routeParams', '$location', 'nodeResource', 'nodeCache', 'NodeModel',
($scope, $routeParams, $location, nodeResource, nodeCache, NodeModel) ->
  cacheQueue = [] # Nodes that need to be fetched
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

  # Fetch the node from the cache, otherwise show a loading message
  tryNodeCache = (u) ->
    cacheQueue.push u unless nodeCache.get u
    nodeCache.get(u) || {title: "Loading...", uuid: u}

  $scope.updateGroupsFromCache = ->
    _.each groups, (group) ->
      _.each $scope[group], (n) ->
        $scope[group][n.uuid] = nodeCache.get n.uuid

  $scope.error = (response) ->
    $scope.errorText = "Something went wrong #{response.status}"

  if $routeParams.id
    $scope.fetchOne($routeParams.id)
  else
    $scope.showPrimary(window.primaryNode)
]
