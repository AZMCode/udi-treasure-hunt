module ShamirSecretSharing(split,combine) where

import Prelude

import Effect(Effect)
import Effect.Aff(Aff)
import Data.Maybe(Maybe(..))
import Data.ArrayBuffer.Types(Uint8Array)
import Control.Promise(Promise,toAffE)

foreign import splitRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Uint8Array -> Int -> Int -> Effect (Promise (Maybe (Array Uint8Array)))

split :: Uint8Array -> Int -> Int -> Aff (Maybe (Array Uint8Array))
split secret total threshold = toAffE $ splitRaw Just Nothing secret total threshold

foreign import combineRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> (Array Uint8Array) -> Effect (Promise (Maybe Uint8Array))

combine :: Array Uint8Array -> Aff (Maybe Uint8Array)
combine = toAffE <<< combineRaw Just Nothing