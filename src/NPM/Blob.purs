module Blob(fromUint8Array) where

import Prelude

import Data.ArrayBuffer.Types(Uint8Array)
import Web.File.Blob(Blob)

foreign import fromUint8Array :: Uint8Array -> Blob