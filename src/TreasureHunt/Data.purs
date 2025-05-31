module TreasureHunt.Data(codec,AssetData(..),assetData,assetDataToJSON) where

import Prelude

import Data.ArrayBuffer.Custom(uint8ArrayArbitrary, uint8ArrayEq, uint8ArrayShow)
import Data.Either(hush)
import Data.Maybe(Maybe)
import Data.Profunctor(dimap)
import Test.QuickCheck.Arbitrary(class Arbitrary,arbitrary)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.ArrayBuffer.Custom(uint8ArrayCodec)
import Data.Argonaut (jsonParser,stringify)
import Data.Codec.Argonaut(object,int,prismaticCodec,decode,encode,JsonCodec) as CA
import Data.Codec.Argonaut.Record(record) as CAR


foreign import assetDataJson :: String

data AssetData = MkAssetData {
        cyphertext :: Uint8Array,
        threshold  :: Int       ,
        total      :: Int       ,
        publicKey  :: Uint8Array
    }

instance showAssetData :: Show AssetData where
    show (MkAssetData { cyphertext, threshold, total, publicKey }) = 
        "MkAssetData { " <> 
              "cyphertext: " <> uint8ArrayShow cyphertext   <>
            ", threshold: "  <> show threshold              <>
            ", total: "      <> show total                  <>
            ", publicKey: "  <> uint8ArrayShow publicKey    <>
            "}"

instance eqAssetData :: Eq AssetData where
    eq (MkAssetData a) (MkAssetData b) =
        uint8ArrayEq a.cyphertext   b.cyphertext &&
                     a.threshold == b.threshold  &&
                     a.total     == b.total      &&
        uint8ArrayEq a.publicKey    b.publicKey

instance arbitraryAssetData :: Arbitrary AssetData where
    arbitrary = do
        cyphertext <- uint8ArrayArbitrary 
        threshold  <- arbitrary 
        total      <- arbitrary 
        publicKey  <- uint8ArrayArbitrary
        pure $ MkAssetData { cyphertext, threshold, total, publicKey }


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
