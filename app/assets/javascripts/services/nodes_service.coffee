# Resource /Model (?)
Tangle.tangle = angular.module("tangle", ["ngResource"]).
  factory("Node",
          (($resource) -> $resource "/nodes/:node_id/:action.json"),
          { node_id: "@id" },
          { update:{ method: "PUT"}}
).factory('NodeCache', ($cacheFactory) ->
  $cacheFactory('nodeCache', { capacity: 1000 }) # LRU cache
)

Tangle.NodesController = ($scope, Node, NodeCache) ->
  cacheQueue = []
  groups = ['childNodes', 'companionNodes', 'parentNodes']

  $scope.resetGroups = -> _.each groups, (p) -> $scope[p] = {}

  # Fetchers
  $scope.fetchOne= (nodeId) ->
    Node.get node_id: nodeId,
      ((resource) -> $scope.showPrimary(resource)),
      ((response) -> $scope.error response)

  $scope.fetchList= (nodeIds) ->
    Node.query ids: nodeIds,
      ((response) -> $scope.indexFetched(response)),
      ((response) -> $scope.error response)

  $scope.indexFetched = (nodes) ->
    _.each nodes, (n) -> NodeCache.put(n.uuid, n)
    $scope.updateGroupsFromCache()

  # Display Nodes
  $scope.focusNode = (nodeGuid) ->
    if NodeCache.get nodeGuid
      $scope.showPrimary(NodeCache.get nodeGuid)
    else
      $scope.fetchOne(nodeGuid)

  $scope.showPrimary= (node) ->
    $scope.resetGroups()
    NodeCache.put(node.uuid, node) if !NodeCache.get node.uuid
    $scope.primaryNode = node
    $scope.showRelationships(node)

  $scope.showRelationships = (node) ->
    # Display the nodes we have and queue the rest
    $scope.childNodes = $scope.tryNodes(node.child_uuids)
    $scope.compaionNodes = $scope.tryNodes(node.companion_uuids)
    $scope.parentNodes = $scope.tryNodes(node.parent_uuids)
    # Now that child, parent, companion nodes are queued, fetch it
    $scope.fetchList(cacheQueue) if cacheQueue.length > 0
    cacheQueue = []

  $scope.tryNodes = (nodeUuids) ->
    result = {}
    _.each nodeUuids, (u) -> result[u] = tryNodeCache(u)
    result

  tryNodeCache = (u) ->
    unless NodeCache.get u
      cacheQueue.push u
      NodeCache.put(u, {title: "Loading...", uuid: u})
    NodeCache.get u

  $scope.updateGroupsFromCache = ->
    _.each groups, (p) ->
      _.each $scope[p], (n) ->
        $scope[p][n.uuid] = NodeCache.get n.uuid

  $scope.error = (response) ->
    console.log "Error", response
    $scope.errorText = "Something went wrong #{response.status}"

  # INITALIZE ####
  $scope.showPrimary(window.primaryNode)