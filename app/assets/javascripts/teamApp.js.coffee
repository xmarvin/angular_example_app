teamApp = angular.module('teamApp', ['ngResource', 'ngRoute', 'mk.editablespan', 'ui.sortable'])

teamApp.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

teamApp.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when '/',  templateUrl: '/templates/team_list.html', controller: 'TeamListController'#,  activetab: 'dashboard'
  $routeProvider.when '/search',  templateUrl: '/templates/search.html', controller: 'SearchController'#,  activetab: 'search'
  $routeProvider.when '/dashboard', templateUrl: '/templates/dashboard.html', controller: 'DashboardController'
  $routeProvider.when '/task_lists/:list_id', templateUrl: '/templates/task_list.html', controller: 'TodoListController'