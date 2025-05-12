module TreasureHunt.Data(AssetData(..),assetData) where

import Prelude

import Data.Either(hush)
import Data.Maybe(Maybe)
import Data.Profunctor(dimap)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Argonaut (jsonParser)
import Data.Codec.Argonaut(object,string,int,prismaticCodec,decode,JsonCodec) as CA
import Data.Codec.Argonaut.Record(record) as CAR
import Scure.Base32(encode,decode) as B32


foreign import assetDataJson :: String

data AssetData = MkAssetData {
        cyphertext :: Uint8Array,
        threshold  :: Int       ,
        publicKey  :: Uint8Array
    }


uint8ArrayCodec :: CA.JsonCodec Uint8Array
uint8ArrayCodec = CA.prismaticCodec "Uint8Array" B32.decode B32.encode CA.string

codec :: CA.JsonCodec AssetData
codec = dimap unAssetData MkAssetData $ CA.object "AssetData" $
    CAR.record {
        cyphertext: uint8ArrayCodec,
        threshold: CA.int,
        publicKey: uint8ArrayCodec
    }
    where
        unAssetData (MkAssetData x) = x

assetData :: Maybe AssetData
assetData = (hush <<< CA.decode codec) =<< (hush $ jsonParser assetDataJson)
