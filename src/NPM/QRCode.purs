module QRCode where

import Prelude

import Effect(Effect)
import Effect.Aff(Aff)
import Data.Maybe(Maybe(..))
import Data.ArrayBuffer.Types(Uint8Array)
import Control.Promise(Promise,toAffE)

foreign import toDataURLRaw :: (String -> Maybe String) -> Maybe String -> String -> Effect (Promise (Maybe String))

toDataURL :: String -> Aff (Maybe String)
toDataURL = toAffE <<< toDataURLRaw Just Nothing