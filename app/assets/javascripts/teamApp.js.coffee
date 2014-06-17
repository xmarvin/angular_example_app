teamApp = angular.module('teamApp', ['ngResource', 'ngRoute', 'mk.editablespan', 'ui.sortable'])

teamApp.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

teamApp.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when '/',  templateUrl: '/templates/typeahead.html', controller: 'TeamListController'
  $routeProvider.when '/search',  templateUrl: '/templates/search.html', controller: 'SearchController'