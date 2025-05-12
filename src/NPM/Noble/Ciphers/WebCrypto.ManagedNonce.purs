module Noble.Ciphers.WebCrypto.ManagedNonce (ManagedNonce,encrypt,decrypt) where

import Effect(Effect)
import Data.Maybe(Maybe(..))
import Data.ArrayBuffer.Types(Uint8Array)

foreign import data ManagedNonce :: Type

foreign import encryptRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> ManagedNonce -> Uint8Array -> Uint8Array -> Effect (Maybe Uint8Array)

foreign import decryptRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> ManagedNonce -> Uint8Array -> Uint8Array -> Maybe Uint8Array

encrypt :: ManagedNonce -> Uint8Array -> Uint8Array -> Effect (Maybe Uint8Array)
encrypt = encryptRaw Just Nothing

decrypt :: ManagedNonce -> Uint8Array -> Uint8Array -> Maybe Uint8Array
decrypt = decryptRaw Just Nothing