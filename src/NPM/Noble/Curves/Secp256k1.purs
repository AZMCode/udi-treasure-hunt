module Noble.Curves.Secp256k1(randomPrivateKey,getPublicKey,sign,verify) where

import Effect(Effect)
import Data.ArrayBuffer.Types(Uint8Array)
import Data.Maybe(Maybe(..))

foreign import randomPrivateKey :: Effect Uint8Array

foreign import getPublicKeyRaw  :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Uint8Array -> Maybe Uint8Array

foreign import signRaw          :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Uint8Array -> Uint8Array -> Maybe Uint8Array

foreign import verifyRaw        :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Uint8Array -> Uint8Array -> Uint8Array -> Maybe Uint8Array

getPublicKey :: Uint8Array -> Maybe Uint8Array
getPublicKey = getPublicKeyRaw Just Nothing

sign :: Uint8Array -> Uint8Array -> Maybe Uint8Array
sign = signRaw Just Nothing

verify :: Uint8Array -> Uint8Array -> Uint8Array -> Maybe Uint8Array
verify = verifyRaw Just Nothing