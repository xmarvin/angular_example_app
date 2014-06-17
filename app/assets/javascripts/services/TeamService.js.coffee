angular.module('teamApp').factory 'TeamService', ($resource, $http, TeamMemberService) ->
  class TeamService
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

    #Move to the Team model
    createTeamMember: (team, userId, successHandler) =>
      teamMembersService = new TeamMemberService(team.id, @errorHandler)

      teamMembersService.create { user_id: userId }, (team_member) ->
        team.team_members.unshift(team_member)
        team.team_members_ids ||= []
        team.team_members_ids.unshift(team_member.user_id)
        team.team_members_length = team.team_members_ids.length
        successHandler(team_member) if successHandler

    deleteTeamMember: (team, team_member_index, successHandler) =>
      teamMembersService = new TeamMemberService(team.id, @errorHandler)
      team_member = team.team_members[team_member_index]
      if team_member
        teamMembersService.delete team_member, (res) ->
          team.team_members.splice(team_member_index, 1)
          team.team_members_ids ||= []
          ind = team.team_members_ids.indexOf(team_member.user_id)
          if ind >= 0
            team.team_members_ids.splice(ind, 1)

          team.team_members_length = team.team_members_ids.length
          successHandler(res) if successHandler