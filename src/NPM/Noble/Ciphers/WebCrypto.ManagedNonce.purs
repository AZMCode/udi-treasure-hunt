module Noble.Ciphers.WebCrypto.ManagedNonce (ManagedNonce,encrypt,decrypt,Plaintext,Cyphertext,Key) where

import Effect(Effect)
import Data.Maybe(Maybe(..))
import Data.ArrayBuffer.Types(Uint8Array)

foreign import data ManagedNonce :: Type

foreign import encryptRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> ManagedNonce -> Key -> Plaintext -> Effect (Maybe Cyphertext)

foreign import decryptRaw :: (Uint8Array -> Maybe Uint8Array) -> Maybe Uint8Array -> ManagedNonce -> Key -> Cyphertext -> Maybe Plaintext

type Cyphertext = Uint8Array
type Plaintext  = Uint8Array
type Key        = Uint8Array

encrypt :: ManagedNonce -> Key -> Plaintext -> Effect (Maybe Cyphertext)
encrypt = encryptRaw Just Nothing

decrypt :: ManagedNonce -> Key -> Cyphertext -> Maybe Plaintext
decrypt = decryptRaw Just Nothing