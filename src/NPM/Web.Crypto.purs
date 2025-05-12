module Web.Crypto(getRandomValues) where

import Effect(Effect)
import Data.Maybe(Maybe(..))
import Data.ArrayBuffer.Types(Uint8Array)

foreign import getRandomValuesRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Int -> Effect (Maybe Uint8Array)

getRandomValues = getRandomValuesRaw Just Nothing