angular.module('teamApp').factory 'TeamService', ($resource, $q, $http, TeamMemberService) ->
  class Team
    constructor: (attrs, errorHandler) ->
      @attrs = attrs
      @id = attrs.id
      @name = attrs.name
      @team_members_length = attrs.team_members_length

      @_teamMembersService = new TeamMemberService(@id, () -> errorHandler() )
      @_team_members = []
      @_team_members_ids = []
      @_team_members_deferred = null
      @_is_team_members_loaded = false


    team_members: =>
      unless @_is_team_members_loaded
        @getTeamMembers()
      @_team_members || []

    getTeamMembers: =>
      need_request = @_team_members_deferred == null
      @_team_members_deferred ||= $q.defer()
      if @_is_team_members_loaded
        @_team_members_deferred.resolve(@_team_members)
      else if need_request
        @_teamMembersService.all (res) =>
          @_team_members = res
          @_team_members_ids = $.map(res, (team_member) -> team_member.user_id)
          @_is_team_members_loaded = true
          @_team_members_deferred.resolve(@_team_members)
          @team_members_length = @_team_members_ids.length

      @_team_members_deferred.promise

    refreshTeamMembers: (for_insert, for_delete, successCallback) =>
      @_teamMembersService.refresh {for_insert_ids: for_insert, for_delete_ids: for_delete}, () =>
        @_is_team_members_loaded = false
        @_team_members = []
        @_team_members_ids = []
        @_team_members_deferred = null
        @getTeamMembers()
        successCallback() if successCallback



    deleteTeamMember: (team_member_index, successHandler) =>
      team_member = @_team_members[team_member_index]
      if team_member
        @_teamMembersService.delete team_member, (res) =>
          @_team_members.splice(team_member_index, 1)
          @_team_members_ids ||= []
          ind = @_team_members_ids.indexOf(team_member.user_id)
          if ind >= 0
            @_team_members_ids.splice(ind, 1)

          @team_members_length = @_team_members_ids.length
          successHandler(res) if successHandler


    createTeamMember: (userId, successHandler) =>
      @_teamMembersService.create { user_id: userId }, (team_member) =>
        @_team_members.push(team_member)
        @_team_members_ids.push(team_member.user_id)
        @team_members_length = @_team_members_ids.length
        successHandler(team_member) if successHandler

    hasMember: (member) =>
      member.id in @_team_members_ids

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

    all: (successCallback) =>
      @service.query (res) =>
        res = $.map res, (attrs) => new Team(attrs, @errorHandler)
        successCallback(res)
      , @errorHandler

    create: (attrs, successHandler) =>
      new @service(team: attrs).$save (res) =>
        res = new Team(res)
        successHandler(res)
      , @errorHandler

    delete: (team, successHandler) =>
      new @service().$delete {id: team.id}, successHandler, @errorHandler