module Access.Record where

import Native.Access
import Debug

setter : (rec -> b) -> b -> rec -> rec
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
