@app.controller "BooksController", ["$scope", "$resource", "Book", ($scope, $resource, Book) ->

  init = ->
    $scope.books = Book.index()

  $scope.books = []
  init()

#  $scope.submitTopic = ->
#    alert $scope.topic
#    Topic.create(topic: $scope.topic)

]
