angular.module('teamApp').directive 'inputToken', ->
  restrict: 'A'
  scope:
    onAdd: '='
    onDelete: '='
    selectedMembers: '='

  link: (scope, element, attrs) ->
    $(element).tokenInput "/api/users",
      jsonContainer: 'users'
      theme: "facebook",
      preventDuplicates: true
      resultsFormatter: (item) ->
        "<li>#{item.name}, #{item.grade} #{item.position}</li>"
      minChars: 2
      onAdd: (new_item)->
        return if scope.isOnMaintain
        scope.isOnMaintain = true
        scope.$apply () ->
          scope.onAdd(new_item)
        scope.isOnMaintain = false

      onDelete: (new_item) ->
        return if scope.isOnMaintain
        scope.isOnMaintain = true
        scope.$apply () ->
          scope.onDelete(new_item)
        scope.isOnMaintain = false


    scope.$watch 'selectedMembers', (team_members)->
      return if scope.isOnMaintain
      scope.isOnMaintain = true
      $(element).tokenInput("clear");
      if team_members
        $.each team_members, (index, team_member) ->
          $(element).tokenInput("add", {id: team_member.user.id, name: team_member.user.name});

        scope.isOnMaintain = false

    , true
