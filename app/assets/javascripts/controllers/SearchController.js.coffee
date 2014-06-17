angular.module('teamApp').controller "SearchController", ($scope, Member) ->
  serverErrorHandler = ->
    alert("There was a server error, please reload the page and try again.")

  @listsService = new Member(serverErrorHandler)
  $scope.members = []
  $scope.pagination = {}

  $scope.addToActiveTeam = (member) =>
    console.log "add to the team"
    console.log(member)
    false

  $scope.showReviews = (member) =>
    console.log "loading reviews"
    console.log(member)

  $scope.nextPage = () =>
    page = $scope.pagination.current_page
    total_pages = $scope.pagination.total_pages
    if page < total_pages
      loadUsers(page + 1)
      
  $scope.prevPage = () =>
    page = $scope.pagination.current_page
    if page > 1
      loadUsers(page - 1)

  loadUsers = (page) =>
    @listsService.search page, 'qw', (res) ->
      $scope.members = res.users
      $scope.pagination = res.pagination

  loadUsers(1)


  $scope
