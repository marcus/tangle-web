Tangle.mods = [
  'tangle.service'
  'tangle.directive'
  'tangle.filter'
]

Tangle.routesConfig = ($routeProvider, $routeParams) ->
  console.log "providing", $routeParams
  $routeProvider.when('/nodes/:id', {template: 'index.html', controller: Tangle.NodesController})
  $routeProvider.otherwise(redirectTo: '/')

angular.module("tangle.service", ["ngResource"]).
  factory("Node",
    (($resource) ->
      $resource "/nodes/:node_id/:action.json"),
    { node_id: "@id" },
    { update:{ method: "PUT"}}
).factory('NodeCache',
    ($cacheFactory) ->
      $cacheFactory('nodeCache', { capacity: 1000 }) # LRU cache
)

angular.module('tangle.directive', [])
angular.module('tangle.filter', [])

angular.module('tangle', Tangle.mods).run().config(['$routeProvider', Tangle.routesConfig])

#angular.element(document).ready ()->
  #angular.bootstrap(document,['app'])
