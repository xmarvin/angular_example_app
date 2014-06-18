angular.module('teamApp').controller "TeamListController", ($scope, TeamService) ->

  serverErrorHandler = (res,error) ->
    err = "There was a server error, please reload the page and try again."
    err_data = res.data
    if err_data
      err = err_data[0]
    alert(err)

  resetActiveTeam = ->
    if $scope.activeTeam == null && $scope.teams.length > 0
      $scope.activateTeam $scope.teams[0]

  @teamsService = new TeamService(serverErrorHandler)

  @teamsService.all (res) ->
    $scope.teams = res
    resetActiveTeam()

  $scope.teamName = ""
  $scope.addTeam = =>
    @teamsService.create name: $scope.teamName, (team) ->
      $scope.teams.push(team)
      $scope.teamName = ""

  $scope.canAddTeam = ->
    $.trim($scope.teamName).length > 0

  $scope.activeTeam = null

  $scope.activateTeam = (team) =>
    $scope.activeTeam = team

  $scope.deleteTeam = (team, index) =>
    @teamsService.delete team, () =>
      $scope.teams.splice index, 1
      if team == $scope.activeTeam
        $scope.activeTeam = null
        resetActiveTeam()


  $scope.isActive = (team) ->
    $scope.activeTeam == team


  $scope.selectMember = (member) =>
    $scope.activeTeam.selectedMembers.push(member)

  $scope.resetMembers = () =>
    $scope.activeTeam.selectedMembers = $scope.activeTeam.team_members()

  $scope.addToActiveTeam = (member) =>
    if $scope.activeTeam
      $scope.activeTeam.createTeamMember member.id
    false

  $scope.deleteFromActiveTeam = (team, $index) =>
    if $scope.activeTeam
      $scope.activeTeam.deleteTeamMember $index
    false

  $scope.isMemberOfTeam = (member) =>
    $scope.activeTeam.hasMember(member)

  $scope
