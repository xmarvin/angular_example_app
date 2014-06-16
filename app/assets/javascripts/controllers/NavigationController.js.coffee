angular.module('teamApp').controller "NavigationController", ($scope, $location) ->
  $scope.activetab = $location.path()[1..-1]
  $scope

