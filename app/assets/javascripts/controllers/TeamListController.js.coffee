angular.module('teamApp').controller "TeamListController", ($scope, Team, Member) ->
  @listsService = new Team(serverErrorHandler)
  $scope.teams = @listsService.all()

  serverErrorHandler = ->
    alert("There was a server error, please reload the page and try again.")

  $scope
