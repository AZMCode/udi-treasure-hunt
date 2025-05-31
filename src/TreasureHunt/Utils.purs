module TreasureHunt.Utils where

import Prelude

import Halogen.HTML (div_,HTML) as HH
import Halogen (HalogenQ, HalogenM) as H
import Data.Either(hush)
import Data.Codec.Argonaut(JsonCodec,string,prismaticCodec)
import Data.ArrayBuffer.Types(Uint8Array)
import Data.Binary.Base64(encodeUrl,decode)

type Eval state query action slots input output m = H.HalogenQ query action input ~> H.HalogenM state action slots output m

emptyDiv :: forall w i. HH.HTML w i
emptyDiv = HH.div_ []

uint8ArrayCodec :: JsonCodec Uint8Array
uint8ArrayCodec = prismaticCodec "Uint8Array" (hush <<< decode) encodeUrl string

foreign import uint8ArrayEq :: Uint8Array -> Uint8Array -> Boolean