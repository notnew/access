module Access where

import Native.Access

setter : String -> (rec -> b) -> b -> rec -> rec
setter name getter =
  Native.Access.makeRecordSetter name

