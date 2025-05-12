module Scure.Base32(encode, decode) where

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Maybe(Maybe(..))

foreign import encode :: Uint8Array -> String

foreign import decodeRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> String -> Maybe Uint8Array

decode :: String -> Maybe Uint8Array
decode = decodeRaw Just Nothing 