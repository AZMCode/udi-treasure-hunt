module Noble.Hashes.SHA3(sha3_512) where

import Data.ArrayBuffer.Types(Uint8Array)

foreign import sha3_512 :: Uint8Array -> Uint8Array