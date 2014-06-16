angular.module('teamApp').controller "SearchController", ($scope, Member) ->

  @listsService = new Member(serverErrorHandler)
  $scope.members = @listsService.all()

  serverErrorHandler = ->
    alert("There was a server error, please reload the page and try again.")

  $scope
