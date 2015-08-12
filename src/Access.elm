module Access where

import Native.Access
import Debug

setter : (rec -> b) -> b -> rec -> rec
setter getter =
  Native.Access.makeRecordSetter getter

