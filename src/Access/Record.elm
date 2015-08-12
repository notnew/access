module Access.Record where

import Native.Access
import Debug

setter : (rec -> b) -> b -> rec -> rec
setter getter =
  Native.Access.makeRecordSetter getter

unsafeSetter : (oldRec -> b) -> new -> oldRec -> newRec
unsafeSetter getter =
  Native.Access.makeRecordSetter getter

