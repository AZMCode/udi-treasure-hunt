module Data.ArrayBuffer.Custom(fromArray,toArray,uint8ArrayArbitrary,uint8ArrayCodec,uint8ArrayShow,uint8ArrayEq) where

import Prelude

import Test.QuickCheck.Gen(Gen)
import Test.QuickCheck.Arbitrary(arbitrary)
import Data.Either(hush)
import Data.Codec.Argonaut(JsonCodec,string,prismaticCodec)
import Data.ArrayBuffer.Types(Uint8Array)
import Data.Binary.Base64(encodeUrl,decode)

foreign import fromArray :: Array Int -> Uint8Array

foreign import toArray :: Uint8Array -> Array Int

foreign import uint8ArrayEq :: Uint8Array -> Uint8Array -> Boolean

uint8ArrayArbitrary :: Gen Uint8Array
uint8ArrayArbitrary = fromArray <$> arbitrary

uint8ArrayCodec :: JsonCodec Uint8Array
uint8ArrayCodec = prismaticCodec "Uint8Array" (hush <<< decode) encodeUrl string

uint8ArrayShow :: Uint8Array -> String
uint8ArrayShow a = "Uint8Array " <> (show $ toArray a)