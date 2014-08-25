@app.factory "Book", ["$resource", ($resource) ->
    $resource( "/books/:id.json",
      {id: @id}
      {
       index: { method: 'get', isArray: true },
       create: { method: 'post'}
      }
    )
]
