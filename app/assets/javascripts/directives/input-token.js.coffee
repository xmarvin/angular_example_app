angular.module('teamApp').directive 'inputToken', ->
  restrict: 'A'
  scope:
    team: '='
    onAdd: '='
  link: (scope, element, attrs) ->
    $(element).tokenInput "/api/users",
      jsonContainer: 'users'
      theme:"facebook",
      preventDuplicates: true
      minChars: 3
      onAdd: (new_item)->
        return if scope.isOnMaintain
        scope.$apply () ->
          scope.onAdd(new_item)

    scope.$watch 'team._team_members', (team_members)->
      $(element).tokenInput("clear");
      if team_members
        scope.isOnMaintain = true
        $.each team_members, (index, team_member) ->
          $(element).tokenInput("add", {id: team_member.id, name: team_member.user.name});
        $.each scope.team.selectedMembers, (index, team_member) ->
          $(element).tokenInput("add", {id: team_member.id, name: team_member.name});

        scope.isOnMaintain = false

    , true
