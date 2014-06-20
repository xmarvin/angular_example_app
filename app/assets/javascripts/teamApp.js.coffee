teamApp = angular.module('teamApp', ['ngResource', 'ngRoute'])

teamApp.config ($httpProvider, $parseProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
  $parseProvider.unwrapPromises(true)

teamApp.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when '/',  templateUrl: '/templates/typeahead.html', controller: 'TypeAheadController'
  $routeProvider.when '/search',  templateUrl: '/templates/search.html', controller: 'SearchController'