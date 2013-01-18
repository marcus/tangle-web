#Tangle.tangle = angular.module('tangle',['nodeService', 'ngResource'])#.
  #config(($routeProvider) ->
    #$routeProvider.
      #when('/', controller: Tangle.ListController, template: 'list.html').
      #otherwise(redirectTo:'/')
  #)

#Tangle.ListController = ($scope, Tangle) ->
  #console.log "hum"
  #$scope.nodes = Tangle.Node.query()
