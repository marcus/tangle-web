#Tangle.NodesCtrl = ($scope, $http) ->
  #$http.get("/nodes.json", {cache: true}).success((data) ->
    #$scope.nodes = data
    #console.log data
  #).error((data, status) ->
    #console.log "Error in NodesCtrl fetch", data, status
  #)

# Resource /Model (?)
Tangle.tangle = angular.module("tangle", ["ngResource"]).
  factory("Node",
          (($resource) -> $resource "/nodes/:node_id/:action.json"),
          { node_id: "@id" },
          { update:{ method: "PUT"}}
)

# Controller
Tangle.NodesController = ($scope, Node) ->
  cache = {}
  cacheQueue = []
  # Check resetGroups for the children/parents/companions

  # Fetchers
  $scope.fetchOne= (nodeId) ->
    Node.get node_id: nodeId,
      ((resource) -> $scope.showPrimary(resource)),
      ((response) -> $scope.error response)

  $scope.fetchIndex = (nodeIds) ->
    Node.query ids: nodeIds,
      ((response) -> $scope.indexFetched(response)),
      ((response) -> $scope.error response)

  $scope.indexFetched = (nodes) ->
    _.each nodes, (n) -> cache[n.uuid] = n
    $scope.updateGroupsFromCache()

  # Display Nodes
  $scope.focusNode = (nodeGuid) ->
    if cache[nodeGuid]
      $scope.showPrimary(cache[nodeGuid])
    else
      $scope.fetchOne(nodeGuid)

  $scope.showPrimary= (node) ->
    $scope.resetGroups()
    cache[node.uuid] ||= node
    $scope.primaryNode = node
    $scope.showRelationships(node)
    console.log(node)

  $scope.showRelationships = (node) ->
    # TODO - sort relationships alpha
    # Display the nodes we have and queue the rest
    $scope.childNodes = $scope.tryNodes(node.child_uuids)
    $scope.compaionNodes = $scope.tryNodes(node.companion_uuids)
    $scope.parentNodes = $scope.tryNodes(node.parent_uuids)
    # Now that child, parent, companion nodes are queued, fetch it
    $scope.fetchIndex(cacheQueue) if cacheQueue.length > 0
    cacheQueue = [] # Clear the queue now that everything is cached and magically displayed!

  $scope.tryNodes = (nodeUuids) ->
    result = {}
    _.each nodeUuids, (u) -> result[u] = tryNodeCache(u)
    result

  tryNodeCache = (u) ->
    unless cache[u]
      cacheQueue.push u
      cache[u] = {title: "Loading...", uuid: u}
    cache[u]

  $scope.updateGroupsFromCache = ->
    _.each ['childNodes', 'companionNodes', 'parentNodes'], (p) ->
      _.each $scope[p], (n) ->
        $scope[p][n.uuid] = cache[n.uuid]
    console.log "updating groups", $scope.childNodes

  $scope.resetGroups = ->
    _.each ['childNodes', 'companionNodes', 'parentNodes'], (p) ->
      $scope[p] = {}

  $scope.error = (response) ->
    console.log "Error", response
    $scope.errorText = "Something went wrong #{response}"

  # INITALIZE ####
  $scope.showPrimary(window.primaryNode)
