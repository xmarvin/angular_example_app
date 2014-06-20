angular.module('teamApp').controller "TypeAheadController", ($scope, activeTeamService) ->
  $scope.activeTeam = null
  $scope.selectedMembers = []
  $scope.selectedMembersChanged = false

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

  $scope.onTeamChanged = () ->
    $scope.activeTeam = activeTeamService.team
    $scope.resetMembers()

  $scope.$on 'activeTeamChanged', $scope.onTeamChanged
  $scope.$on 'setSelectedMembers', $scope.resetMembers


  $scope.onTeamChanged()

  $scope
