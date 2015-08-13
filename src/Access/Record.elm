module Access.Record where

import Native.Access
import Debug

{-| Make a setter function for a record from a record getter. The getter function must be a builtin Elm "dot accessor function" like `.x` or `.velocity` or a runtime error will result.

    setX : value ->  { a | x : value } -> { a | x : value }
    setX = setter .x
    setX 42 { x=9, y=10 } == { x=42, y=10 }
-}
setter : (record -> value) -> value -> record -> record
setter getter =
  Native.Access.makeRecordSetter getter

unsafeSetter : (oldRec -> b) -> new -> oldRec -> newRec
unsafeSetter getter =
  Native.Access.makeRecordSetter getter

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
