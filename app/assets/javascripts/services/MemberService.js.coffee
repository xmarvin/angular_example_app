angular.module('teamApp').factory 'Member', ($resource, $http) ->
  class Member
    constructor: (errorHandler) ->
      @service = $resource('/staff.json')
      @errorHandler = errorHandler

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    all: ->
      @service.query((-> null), @errorHandler)
