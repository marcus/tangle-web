#Tangle.NodesCtrl = ($scope, $http) ->
  #$http.get("/nodes.json", {cache: true}).success((data) ->
    #$scope.nodes = data
    #console.log data
  #).error((data, status) ->
    #console.log "Error in NodesCtrl fetch", data, status
  #)

# Resource
angular.module("nodeService", ["ngResource"]).factory "Node", ($resource) ->
  $resource "/nodes/:node_id/:action.json", { node_id: "@id" }, { update:{ method: "PUT"}}

# Controller
Tangle.NodesController = ($scope, Node) ->
  $scope.index = ->
    console.log "Index"
    Node.query ((resource) -> console.log resource
    ), (response) -> console.log response

  $scope["new"] = ->
    console.log "New"
    Node.get
      action: "new"
    , ((resource) -> console.log resource
    ), (response) -> console.log response

  $scope.show = (t_id) ->
    console.log "Show"
    Node.get
      node_id: t_id
    , ((resource) -> console.log resource
    ), (response) -> console.log response

  $scope.edit = (t_id) ->
    console.log "Edit"
    Node.get
      node_id: t_id
      action: "edit"
    , ((resource) -> console.log resource
    ), (response) -> console.log response

  # data in JSON, eg, {title: 'new node'}
  $scope.create = (data) ->
    console.log "Create"
    Node.save {}, data, ((resource) -> console.log resource
    ), (response) -> console.log response

  # data in JSON, eg, {title: 'edited node'}
  $scope.update = (t_id, data) ->
    console.log "Update"
    Node.update
      node_id: t_id
    , data, ((resource) -> console.log resource
    ), (response) -> console.log response


  $scope.destroy = (t_id) ->
    console.log "Destroy"
    Node["delete"]
      node_id: t_id
    , ((resource) ->
      # ajax success
      $("#node_" + t_id).closest("tr").fadeOut()
    ), (response) ->
      # ajax failed
      console.log response
