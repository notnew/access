import Access.Record

import Focus exposing ((=>))

import ElmTest.Test exposing (Test, test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

main =
  runDisplay all

all : Test
all =
  suite "all tests"
        [ setters
        , updaters
        , focus
        , examples
        ]

setters : Test
setters =
  let setX = Access.Record.setter .x
      unsafeX = Access.Record.unsafeSetter .x
      record = { x=5, y="hi"}
  in suite "Setters"
       [ test "setX"
            <| { x=50, y="hi"} `assertEqual` setX 50 record
       , test "polymorphic unsafeX"
            <| { x="set", y="hi"} `assertEqual` unsafeX "set" record
       ]

updaters : Test
updaters =
  let updateX = Access.Record.updater .x
      unsafeX = Access.Record.unsafeUpdater .x
      record = { x=5, y="hi"}
  in suite "Updaters"
       [ test "updateX"
            <| { x=500, y="hi"} `assertEqual` updateX ((*) 100) record
       , test "polymorphic unsafeX"
            <| assertEqual { x="-->5", y="hi"}
                 <| unsafeX ((++) "-->" << toString) record
       ]

focus : Test
focus =
  let x = Access.Record.focus .x
      y = Access.Record.focus .y
      (get, update, set) = (Focus.get, Focus.update, Focus.set)
      record = { x=5, y = { x = { x ="hi" }, y=10} }
  in suite "Focus"
       [ test "get x record"
            <| 5 `assertEqual` get x record
       , test "get ( y => x => x) record"
            <| "hi" `assertEqual` get ( y => x => x) record
       , test "get ( y => y) record"
            <| 10 `assertEqual` get ( y => y) record

       , test "update x record"
            <| assertEqual
                 { x=50, y = { x = { x ="hi" }, y=10} }
                 (update x ((*) 10) record)
       , test "update (y => y) record"
            <| assertEqual
                 { x=5, y = { x = { x ="hi" }, y=18} }
                 (update (y => y) ((+) 8) record)
       , test "update (y => x => x) record"
            <| assertEqual
                 { x=5, y = { x = { x ="_hi" }, y=10} }
                 (update (y => x => x) ((++)  "_") record)

       , test "set (y => x => x) record"
            <| assertEqual
                 { x=5, y = { x = { x ="ok" }, y=10} }
                 (set (y => x => x) "ok" record)
       ]

-- test documented examples
examples : Test
examples =
  suite "examples from documentation"
        [ moduleExamples
        , setterExample
        , unsafeSetterExample
        , updaterExample
        , unsafeUpdaterExample
        , focusExamples
        ]

moduleExamples : Test
moduleExamples =
  let setter = Access.Record.setter
      updater = Access.Record.updater
      incX : { a | x : Float } -> { a | x : Float }
      incX = updater .x ((+) 1)
      player = { velocity = {x=5, y=10}, health=100 }
  in suite "module examples"
       [ test "setter example"
                <| assert
                     <| setter .x 42 { x=0, y=10 } == { x=42, y=10 }
       , test "updater example"
                <| assert
                   <| updater .velocity incX player
                        == { velocity = {x=6, y=10}, health=100 }
       ]

setterExample : Test
setterExample =
  let setX : value ->  { a | x : value } -> { a | x : value }
      setX = setter .x
      setter = Access.Record.setter
  in test "setter example"
       <| assert
          <| setX 42 { x=9, y=10 } == { x=42, y=10 }

unsafeSetterExample : Test
unsafeSetterExample =
  let polySetX : value ->  { a | x : oldValue } -> { a | x : value }
      polySetX = unsafeSetter .x
      unsafeSetter = Access.Record.unsafeSetter
  in test "unsafeSetter example"
       <| assert
          <| polySetX "hello" { x=9, y=10 } == { x="hello", y=10 }

updaterExample : Test
updaterExample =
  let updateX : (value -> value) ->  { a | x : value } -> { a | x : value }
      updateX = updater .x
      updater = Access.Record.updater
  in test "updater example"
       <| assert
          <| updateX ((*) 100) { x=9, y=10 } == { x=900, y=10 }

unsafeUpdaterExample : Test
unsafeUpdaterExample =
  let polyUpdateX : (old -> new) ->  { a | x : old } -> { a | x : new }
      polyUpdateX = unsafeUpdater .x
      unsafeUpdater = Access.Record.unsafeUpdater
  in test "unsafeUpdater example"
       <| assert
            <| polyUpdateX toString { x=9, y=10 } == { x="9", y=10 }

focusExamples : Test
focusExamples =
  let focusX : { get : { a | x : value } -> value
               , update : (value -> value) ->
                          { a | x : value } -> { a | x : value }
               }
      focusX = focus .x
      focus = Access.Record.focus
  in suite "focus example"
       [ test "focus get"
                <| assert
                   <| Focus.get focusX { x=9, y=10 } == 9
       , test "focus set"
              <| assert
                   <| Focus.set focusX 42 { x=9, y=10 } == { x=42, y=10 }
       , test "focus update"
           <| assert
              <| Focus.update focusX ((*) 100) { x=9, y=10 } == { x=900, y=10 }
       ]
