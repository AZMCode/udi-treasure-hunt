module Noble.Ciphers.AES.GCM(aesGcm,encrypt,decrypt) where

import Effect(Effect)
import Noble.Ciphers.WebCrypto.ManagedNonce (ManagedNonce,encrypt,decrypt,Key,Plaintext,Cyphertext) as M
import Data.Maybe(Maybe(..))
import Data.ArrayBuffer.Types(Uint8Array)


foreign import aesGcm :: M.ManagedNonce

encrypt :: M.Key -> M.Plaintext -> Effect (Maybe M.Cyphertext)
encrypt = M.encrypt aesGcm

decrypt :: M.Key -> M.Cyphertext -> Maybe M.Plaintext
decrypt = M.decrypt aesGcm