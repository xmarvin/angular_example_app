angular.module('teamApp').factory 'Member', ($resource, $http) ->
  class Member
    constructor: (errorHandler) ->
      @service = $resource('/api/users/:id',
        {id: '@id'},
        {update: {method: 'PATCH'}, query: {isArray: false }  })
      @errorHandler = errorHandler

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    search: (page, q, successHandler) =>
      @service.query {page: page, q: q}, successHandler, @errorHandler