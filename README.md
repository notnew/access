A library to help create accessor functions

Currently can only create accessor functions for records.

Elm provides builtin "dot accessor" function like `.x` or `.velocity` that make
it easy to extract a field from a record.  This package provides functions to
make setter and updater functions for records, so setting and updating record fields is as easy as getting fields.

    import Access.Record exposing (setter, updater)

    setter .x 42 { x=0, y=10 } == { x=42, y=10 }

    incX : { a | x : Float } -> { a | x : Float }
    incX = updater .x ((+) 1)

    player = { velocity = {x=5, y=10}, health=100 }
    updater .velocity incX player == { velocity = {x=6, y=10}, health=100 }

