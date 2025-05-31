module Noble.Curves.Secp256k1(randomPrivateKey,getPublicKey,sign,verify,PrivateKey,PublicKey,Signature,MessageHash) where

import Effect(Effect)
import Data.ArrayBuffer.Types(Uint8Array)
import Data.Maybe(Maybe(..))

foreign import randomPrivateKey :: Effect Uint8Array

foreign import getPublicKeyRaw  :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Uint8Array -> Maybe Uint8Array

foreign import signRaw          :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Uint8Array -> Uint8Array -> Maybe Uint8Array

foreign import verifyRaw        :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> Uint8Array -> Uint8Array -> Uint8Array -> Maybe Boolean

type PublicKey   = Uint8Array
type PrivateKey  = Uint8Array
type Signature   = Uint8Array
type MessageHash = Uint8Array

getPublicKey :: PrivateKey -> Maybe PublicKey
getPublicKey = getPublicKeyRaw Just Nothing

sign :: PrivateKey -> MessageHash -> Maybe Signature
sign = signRaw Just Nothing

verify :: PublicKey -> MessageHash -> Signature -> Maybe Boolean
verify = verifyRaw Just Nothing