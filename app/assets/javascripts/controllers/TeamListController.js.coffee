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
  $scope.selectedMembers = []
  $scope.selectedMembersChanged = false

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

  $scope.deleteTeam = (team, index) =>
    @teamsService.delete team, () =>
      $scope.teams.splice index, 1
      if team == $scope.activeTeam
        $scope.activeTeam = null
        resetActiveTeam()


  $scope.isActive = (team) ->
    $scope.activeTeam == team

  $scope.unselectMember = (user) =>
    $scope.selectedMembers = $scope.selectedMembers.filter (element) ->
      element.user.id != user.id
    $scope.selectedMembersChanged = true

  $scope.selectMember = (member) =>
    if member.user is undefined
      member = { id: null, user: member }

    $scope.selectedMembers.push(member)
    $scope.selectedMembersChanged = true

  $scope.resetMembers = () =>
    $scope.selectedMembers = []
    $scope.activeTeam.getTeamMembers().then (ts) ->
      $scope.selectedMembers = $.map ts, (el) -> el
    $scope.selectedMembersChanged = false

  $scope.refreshMembers = () =>
    $scope.selectedMembersChanged = false
    existent_ids = $.map $scope.selectedMembers, (el) -> el.id
    members_for_insert = $scope.selectedMembers.filter((element) -> element.id is null).map((el) -> el.user.id)
    members_for_delete = []
    for element, index in $scope.activeTeam.team_members()
      members_for_delete.push(element.id) if element.id != null and element.id not in existent_ids

    $scope.activeTeam.refreshTeamMembers members_for_insert, members_for_delete, ->
      $scope.resetMembers()

  $scope.activateTeam = (team) =>
    $scope.activeTeam = team
    $scope.resetMembers()

  $scope.addToActiveTeam = (member) =>
    if $scope.activeTeam
      $scope.activeTeam.createTeamMember member.id, ->
        $scope.resetMembers()

  $scope.deleteFromActiveTeam = (team, $index) =>
    if $scope.activeTeam
      $scope.activeTeam.deleteTeamMember $index, ->
        $scope.resetMembers()
    false

  $scope.isMemberOfTeam = (member) =>
    $scope.activeTeam.hasMember(member)

  $scope
