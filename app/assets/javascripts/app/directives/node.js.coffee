# The goal is to have this control its own position and click behavior and act as an
# independent class that is aware of other nodes
NodeDirective = ->
  restrict: 'EA'
  #replace: true
  #transclude : true

  templateUrl: '../templates/node.html'

  link: ($scope, $element, $attrs) ->
    $element.on 'click', ->
      $(this).addClass('test')

angular
  .module('tangle')
  .directive('nodeDirective', NodeDirective)
