angular.module('teamApp').factory 'TeamMemberService', ($resource, $http) ->
  class TeamMemberService
    constructor: (teamId, errorHandler) ->
      @teamId = teamId
      @service = $resource('/api/teams/:team_id/team_members/:id',
        {team_id: teamId, id: '@id'},
        {update: {method: 'PATCH'}})
      @errorHandler = errorHandler

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    all: (successHandler) =>
      @service.query(successHandler, @errorHandler)

    create: (attrs, successHandler) =>
      new @service(team_member: attrs).$save successHandler, @errorHandler

    delete: (team_member, successHandler) =>
      new @service().$delete {id: team_member.id}, successHandler, @errorHandler

    refresh: (data, successCallback) ->
      $http.post("/api/teams/#{@teamId}/team_members/refresh", data).success(successCallback);
