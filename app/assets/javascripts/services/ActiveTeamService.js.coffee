angular.module('teamApp').factory 'activeTeamService', ($rootScope) ->
  broadcastItem = (team) ->
    $rootScope.$broadcast 'activeTeamChanged', team

  team: null
  setTeam: (team) ->
    @team = team
    broadcastItem()