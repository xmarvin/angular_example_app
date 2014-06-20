angular.module('teamApp').controller "TeamListController", ($scope, TeamService, activeTeamService) ->
  serverErrorHandler = (res,error) ->
    err = "There was a server error, please reload the page and try again."
    err_data = res.data
    if err_data
      err = err_data[0]
    alert(err)

  notifyResetMembers = ->
    $scope.$broadcast 'setSelectedMembers'

  resetActiveTeam = ->
    if $scope.activeTeam == null && $scope.teams.length > 0
      $scope.activateTeam $scope.teams[0]

  @teamsService = new TeamService(serverErrorHandler)

  $scope.teamName = ""
  $scope.addTeam = =>
    @teamsService.create name: $scope.teamName, (team) ->
      $scope.teams.push(team)
      $scope.teamName = ""

  $scope.canAddTeam = ->
    $.trim($scope.teamName).length > 0

  $scope.activeTeam = null

  $scope.deleteTeam = (team, index) =>
    @teamsService.delete team, () =>
      $scope.teams.splice index, 1
      if team == $scope.activeTeam
        $scope.activeTeam = null
        resetActiveTeam()


  $scope.isActive = (team) ->
    $scope.activeTeam == team


  $scope.activateTeam = (team) =>
    $scope.activeTeam = team
    activeTeamService.setTeam(team)

  $scope.addToActiveTeam = (e, member) =>
    if $scope.activeTeam
      $scope.activeTeam.createTeamMember member.id, ->
        notifyResetMembers()

  $scope.deleteFromActiveTeam = (team, $index) =>
    if $scope.activeTeam
      $scope.activeTeam.deleteTeamMember $index, ->
        notifyResetMembers()
    false

  @teamsService.all (res) ->
    $scope.teams = res
    resetActiveTeam()

  $scope.$on 'addToActiveTeam', $scope.addToActiveTeam

  $scope
