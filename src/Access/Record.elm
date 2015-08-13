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

unsafeUpdater : (oldRec -> b) -> (b -> new) -> oldRec -> newRec
unsafeUpdater getter update rec =
  let old = getter rec
      new = update old
      set = unsafeSetter getter
  in set new rec

focus : (rec -> b) -> { get : rec -> b
                      , update : (b -> b) -> rec -> rec
                      }
focus getter =
  { get = getter
  , update = updater getter
  }
