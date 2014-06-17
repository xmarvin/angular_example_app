angular.module('teamApp').controller "TeamListController", ($scope, Team, Member) ->

  serverErrorHandler = ->
    alert("There was a server error, please reload the page and try again.")

  @teamsService = new Team(serverErrorHandler)

  $scope.teams = @teamsService.all()
  $scope.teamName = ""
  $scope.addTeam = =>
    @teamsService.create name: $scope.teamName, (team) ->
      $scope.teams.unshift(team)
      $scope.teamName = ""

  $scope.canAddTeam = ->
    $.trim($scope.teamName).length > 0

  $scope.activeTeam = null

  $scope.activateTeam = (team) ->
    $scope.activeTeam = team

  $scope.deleteTeam = (team, index) =>
    @teamsService.delete team, () =>
      $scope.teams.splice index, 1
      if team == $scope.activeTeam
        $scope.activeTeam = null

  $scope.isActive = (team) ->
    $scope.activeTeam == team

  $scope
