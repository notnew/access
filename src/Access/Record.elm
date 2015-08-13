module Access.Record where

import Native.Access
import Debug

{-| Make a setter function for a record from a record getter.

    setX : value ->  { a | x : value } -> { a | x : value }
    setX = setter .x
    setX 42 { x=9, y=10 } == { x=42, y=10 }

The getter function must be a builtin Elm "dot accessor function" like `.x` or `.velocity` or a runtime error will result.
-}
setter : (record -> value) -> value -> record -> record
setter getter =
  Native.Access.makeRecordSetter getter

{-| Make a polymorphic setter function for a record from a record getter.

    polySetX : value ->  { a | x : oldValue } -> { a | x : value }
    polySetX = unsafeSetter .x
    polySetX "hello" { x=9, y=10 } == { x="hello", y=10 }

Here "polymorphic" means that the new value that the updated field gets does not have to match the old value.  Notice that the `x` field in the above example changed types from a `number` to a `String`.

This function is "unsafe" because the compiler cannot infer its type completely accurately, which could lead to runtime errors or strange error messages when combined with incorrect code.  These problems can be lessened if the result of calling `unsafeSetter` is given an explicit type (like `polySetX` above).  So it is important to always explicitly annotate the type of variables and functions that depend on calls to `unsafeSetter`.

The getter function must be a builtin Elm "dot accessor function" like `.x` or `.velocity` or a runtime error will result.
-}
unsafeSetter : (oldRecord -> oldValue) -> newValue -> oldRecord -> newRecord
unsafeSetter getter =
  Native.Access.makeRecordSetter getter

{-| Make an updater function for a record from a record getter.

    updateX : (value -> value) ->  { a | x : value } -> { a | x : value }
    updateX = updater .x
    updateX ((*) 100) { x=9, y=10 } == { x=900, y=10 }

The getter function must be a builtin Elm "dot accessor function" like `.x` or `.velocity` or a runtime error will result.
-}
updater : (rec -> b) -> (b -> b) -> rec -> rec
updater =
  unsafeUpdater

{-| Make a polymorphic updater function for a record from a record getter.

    polyUpdateX : (old -> new) ->  { a | x : old } -> { a | x : new }
    polyUpdateX = unsafeUpdater .x
    polyUpdateX toString { x=9, y=10 } == { x="9", y=10 }

Here "polymorphic" and "unsafe" have the same meaning as for `unsafeSetter` above. It is important to always explicitly annotate the type of variables and functions that depend on calls to `unsafeUpdater` for the reasons given above.

The getter function must be a builtin Elm "dot accessor function" like `.x` or `.velocity` or a runtime error will result.
-}
unsafeUpdater : (oldRec -> b) -> (b -> new) -> oldRec -> newRec
unsafeUpdater getter update rec =
  let old = getter rec
      new = update old
      set = unsafeSetter getter
  in set new rec


{-| Make a `Focus` for a record from a record getter.

    focusX : { get : { a | x : value } -> value
             , update : (value -> value) -> { a | x : value } -> { a | x : value }
             }
    focusX = focus .x

As can be seen from the return type, a `Focus` is a getter and a setter stored together in a record. This type is intended to be used with the [focus package][http://package.elm-lang.org/packages/evancz/focus/1.0.1]. Install the package with

    elm-package install evancz/focus

and you can use the functions provided by the focus package on the result of a `focus` call

    focusX = focus .x

    Focus.get focusX { x=9, y=10 } == 9
    Focus.set focusX 42 { x=9, y=10 } == { x=42, y=10 }
    Focus.update focusX ((*) 100) { x=9, y=10 } == { x=900, y=10 }
-}
focus : (rec -> b) -> { get : rec -> b
                      , update : (b -> b) -> rec -> rec
                      }
focus getter =
  { get = getter
  , update = updater getter
  }
