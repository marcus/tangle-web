@tangle.controller 'NodesCtrl', ['$scope', '$routeParams', '$location', '$timeout', 'nodeResource', 'nodeCache', 'NodeModel',
($scope, $routeParams, $location, $timeout, nodeResource, nodeCache, NodeModel) ->
  cacheQueue = [] # Nodes that need to be fetched
  groups = ['childNodes', 'companionNodes', 'parentNodes', 'siblingNodes']

  $scope.resetGroups = -> _.each groups, (p) -> $scope[p] = {}

  $scope.showPrimary = (node) ->
    $scope.resetGroups()
    nodeCache.put(node.uuid, node) if !nodeCache.get node.uuid
    $scope.primaryNode = node
    showRelationships(node)

  $scope.updatePrimary = (nodeId) ->
    $location.url "/nodes/#{nodeId}"

  # Fetchers
  $scope.fetchOne = (nodeId) ->
    NodeModel.get node_id: nodeId,
      ((resource) -> $scope.showPrimary(resource)),
      ((response) -> error response)

  fetchList = (nodeIds) ->
    NodeModel.query ids: _.uniq(nodeIds).join(","),
      ((response) -> indexFetched(response)),
      ((response) -> error response)

  $scope.filterText = ''

  $scope.$watch('searchText', (val) ->
    return unless val
    $timeout.cancel(filterTextTimeout) if (filterTextTimeout)

    tempFilterText = val
    filterTextTimeout = $timeout((->
        $scope.filterText = tempFilterText
        searchList($scope.filterText)
      ), 250)
  )

  searchList = (query) =>
    NodeModel.query q: query,
      ((response) -> showSearchResults(response)),
      ((response) -> error response)

  indexFetched = (nodes) ->
    _.each nodes, (n) ->
      nodeCache.put(n.uuid, n)
    updateGroupsFromCache()

  showSearchResults = (response) ->
    $scope.searchResults = null
    $scope.searchResults = _.map response, (node) -> {title: node.title, uuid: node.uuid}

  showRelationships = (node) ->
    # Display the nodes we have and queue the rest
    $scope.childNodes = tryNodes(node.child_uuids)
    $scope.companionNodes = tryNodes(node.companion_uuids)
    $scope.parentNodes = node.parents # These come down with the primaryNode
    siblingUuids = []
    _.each(node.parents, (p) => siblingUuids = siblingUuids.concat(p.child_uuids))
    $scope.siblingNodes = tryNodes(siblingUuids)
    # Now that child, parent, companion nodes are queued, fetch it
    fetchList(cacheQueue) if cacheQueue.length > 0
    cacheQueue = []

  tryNodes = (nodeUuids) ->
    result = {}
    _.each nodeUuids, (uuid) -> result[uuid] = tryNodeCache(uuid)
    result

  # Fetch the node from the cache, otherwise show a loading message
  tryNodeCache = (uuid) ->
    cacheQueue.push uuid unless nodeCache.get uuid
    #nodeCache.put uuid, {title: "Loading...", uuid: uuid}
    nodeCache.get(uuid) || {title: "Loading...", uuid: uuid}

  updateGroupsFromCache = ->
    _.each groups, (group) ->
      _.each $scope[group], (n) ->
        $scope[group][n.uuid] = nodeCache.get n.uuid

  error = (response) ->
    $scope.errorText = "Something went wrong #{response.status}"

  if $routeParams.id
    $scope.fetchOne($routeParams.id)
  else
    $scope.showPrimary(window.primaryNode)
]
