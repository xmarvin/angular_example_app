angular.module('teamApp').controller "SearchController", ($scope, $timeout, Member) ->
  serverErrorHandler = ->
    alert("There was a server error, please reload the page and try again.")

  @listsService = new Member(serverErrorHandler)
  $scope.members = []
  $scope.pagination = {}

  $scope.showReviews = (member) =>


  filterTextTimeout = null
  $scope.$watch "searchText", (val) ->
    $timeout.cancel filterTextTimeout  if filterTextTimeout
    filterTextTimeout = $timeout(->
      if $scope.searchText isnt undefined
        loadUsers(1, $scope.searchText)
    , 1000)

  $scope.nextPage = () =>
    page = currentPage()
    total_pages = $scope.pagination.total_pages

    if page < total_pages
      loadUsers(page + 1, $scope.searchText)

  $scope.prevPage = () =>
    page = currentPage()
    if page > 1
      loadUsers(page - 1, $scope.searchText)

  currentPage = ->
    $scope.pagination.current_page

  loadUsers = (page, q) =>
    @listsService.search page, q, (res) ->
      $scope.members = res.users
      $scope.pagination = res.pagination

  loadUsers(1, '')


  $scope
