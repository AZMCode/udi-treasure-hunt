module Noble.Ciphers.AES.GCM(aesGcm,encrypt,decrypt) where

import Effect(Effect)
import Noble.Ciphers.WebCrypto.ManagedNonce (ManagedNonce,encrypt,decrypt) as M
import Data.Maybe(Maybe(..))
import Data.ArrayBuffer.Types(Uint8Array)


foreign import aesGcm :: M.ManagedNonce

encrypt :: Uint8Array -> Uint8Array -> Effect (Maybe Uint8Array)
encrypt = M.encrypt aesGcm

decrypt :: Uint8Array -> Uint8Array -> Maybe Uint8Array
decrypt = M.decrypt aesGcm