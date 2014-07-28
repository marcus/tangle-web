angular.module("nodeResource", ["ngResource"]).
  factory("NodeModel",
    (($resource) ->
      $resource "/nodes/:node_id/:action.json"),
    { node_id: "@id" },
    { update:{ method: "PUT"}}
)

# Define the applcation
@tangle = angular.module('tangle', ['ngRoute', 'nodeResource'])

# This routing directive tells Angular about the default route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more sense as we add more routes to our application.
@tangle.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/nodes/:id', {
      templateUrl: '../templates/nodesView.html',
      controller: 'NodesCtrl'
    }).otherwise({
      templateUrl: '../templates/nodesView.html',
      controller: 'NodesCtrl'
    })
])

@tangle.factory("nodeResource", (($resource) ->
  $resource "/nodes/:node_id/:action.json"),
  { node_id: "@id" },
  { update:{ method: "PUT"}}
)

@tangle.factory('nodeCache', ($cacheFactory) ->
 $cacheFactory('nodeCache', { capacity: 1000} )
)

@tangle.filter('unsafe', ($sce) ->
  (val) -> $sce.trustAsHtml(val)
)
