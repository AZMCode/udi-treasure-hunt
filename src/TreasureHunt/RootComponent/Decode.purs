module TreasureHunt.RootComponent.Decode(decode) where

import Prelude

import Effect.Aff(Aff)
import Effect.Aff.Class(liftAff)
import Effect.Class(liftEffect)
import Data.Maybe(Maybe(..),maybe)
import Data.ArrayBuffer.Types(Uint8Array)
import Data.Array(take)
import Noble.Ciphers.AES.GCM(encrypt,decrypt)
import Run(Run,AFF,EFFECT,runBaseAff')
import Run.Except(EXCEPT,runExcept,note,rethrow)
import Data.Either(Either(..))
import Type.Row(type (+))
import Data.TextDecoder(decodeUtf8)
import Data.Bifunctor(lmap)
import Web.File.Url(createObjectURL)

import TreasureHunt.Shard(Shard(..))
import TreasureHunt.Data(AssetData(..),assetData)

import ShamirSecretSharing(combine)
import Blob(fromUint8Array)

decode :: Array Shard -> Aff (Either String String)
decode = runBaseAff' <<< runExcept <<< decodeMain

decodeMain :: forall r. Array Shard -> Run ((EXCEPT String) + AFF + EFFECT + r) String
decodeMain shards = do
    conf      <- note "No se pudo leer la configuración" $ assetData
    let MkAssetData { threshold, cyphertext } = conf
        unShardShare (MkShard { share }) = share
        neededShares = unShardShare <$> take threshold shards
    key       <- join $ note "No se pudo combinar los fragmentos" <$> (liftAff $ combine neededShares)
    plaintext <- note "No se pudo desencriptar el secreto" $ decrypt key cyphertext
    let b = fromUint8Array plaintext
    url <- liftEffect $ createObjectURL b
    pure url



