angular.module('teamApp').factory 'Team', ($resource, $http, TeamMemberService) ->
  class Team
    constructor: (errorHandler) ->
      @service = $resource('/api/teams/:id',
        {id: '@id'},
        {update: {method: 'PATCH'}})
      @errorHandler = errorHandler

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    all: (successCallback)=>
      @service.query(successCallback, @errorHandler)

    create: (attrs, successHandler) =>
      new @service(team: attrs).$save successHandler, @errorHandler

    delete: (team, successHandler) =>
      new @service().$delete {id: team.id}, successHandler, @errorHandler

    loadMembersFor: (team) =>
      team.team_members = []
      teamMembersService = new TeamMemberService(team.id, @errorHandler)
      teamMembersService.all (res) ->
        team.team_members = res
        team.team_members_ids = $.map(res, (team_member) -> team_member.user_id)
        res

    createTeamMember: (team, userId, successHandler) =>
      teamMembersService = new TeamMemberService(team.id, @errorHandler)
      teamMembersService.create { user_id: userId }, (team_member) ->
        team.team_members.unshift(team_member)
        team.team_members_ids ||= []
        team.team_members_ids.unshift(team_member.user_id)
        successHandler(team_member) if successHandler