angular.module('teamApp').factory 'Team', ($resource, $http) ->
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

    all: =>
      @service.query((-> null), @errorHandler)

    create: (attrs, successHandler) =>
      new @service(team: attrs).$save successHandler, @errorHandler

    delete: (team, successHandler) =>
      new @service().$delete {id: team.id}, successHandler, @errorHandler
