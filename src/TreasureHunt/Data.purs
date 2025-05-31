module TreasureHunt.Data(AssetData(..),assetData,assetDataToJSON) where

import Prelude

import Data.Either(hush)
import Data.Maybe(Maybe)
import Data.Profunctor(dimap)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Argonaut (jsonParser,stringify)
import Data.Codec.Argonaut(object,int,prismaticCodec,decode,encode,JsonCodec) as CA
import Data.Codec.Argonaut.Record(record) as CAR
import TreasureHunt.Utils(uint8ArrayCodec)


foreign import assetDataJson :: String

data AssetData = MkAssetData {
        cyphertext :: Uint8Array,
        threshold  :: Int       ,
        total      :: Int       ,
        publicKey  :: Uint8Array
    }

codec :: CA.JsonCodec AssetData
codec = dimap unAssetData MkAssetData $ CA.object "AssetData" $
    CAR.record {
        cyphertext: uint8ArrayCodec,
        threshold:  CA.int,
        total:      CA.int,
        publicKey:  uint8ArrayCodec
    }
    where
        unAssetData (MkAssetData x) = x

assetData :: Maybe AssetData
assetData = (hush <<< CA.decode codec) =<< (hush $ jsonParser assetDataJson)

assetDataToJSON :: AssetData -> String
assetDataToJSON = stringify <<< CA.encode codec
