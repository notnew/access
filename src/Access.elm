module Access where

import Native.Access

setter : (rec -> b) -> b -> rec -> rec
setter getter =
  Native.Access.makeRecordSetter getter

