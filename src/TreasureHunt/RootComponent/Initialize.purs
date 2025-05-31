module TreasureHunt.RootComponent.Initialize(initialize) where

import Prelude

import Effect.Aff(Aff)
import Effect(Effect)
import Effect.Class(liftEffect)
import Web.HTML(Window,window) as H
import Web.HTML.Window(localStorage,location)
import Web.HTML.Location(hash,setHash)
import Web.Storage.Storage(getItem,setItem)
import TreasureHunt.Shard(Shard(..),codec,shardsKey)
import Data.Codec.Argonaut(array,decode,encode) as CA
import Data.Argonaut(jsonParser,stringify) as A
import TreasureHunt.Data(assetData) as D
import Noble.Curves.Secp256k1(verify)
import TreasureHunt.Utils(uint8ArrayEq)
import Data.Maybe(Maybe(..),fromMaybe,maybe)
import Data.Either(hush)
import TreasureHunt.Data(assetData,AssetData(..))
import Data.Array(snoc,filter,nubEq)
import Web.URL.URLSearchParams(URLSearchParams,fromString,get)
import Data.Binary.Base64(decode)
import Data.TextDecoder(decodeUtf8)
import Noble.Hashes.SHA3(sha3_512)
import Data.String.CodePoints(drop)

initialize :: Effect (Array Shard)
initialize = do
    stor       <- localStorage =<< H.window
    shardsStrM <- getItem shardsKey stor
    let startShards = fromMaybe [] $ parseShards =<< shardsStrM
    newSM  <- newShard
    let appendedShards  = maybe startShards (snoc startShards) newSM
        verifiedShards  = filter verifyShard appendedShards
        nubbedShards    = nubEq verifiedShards
        reencodedShards = encodeShards nubbedShards
    setItem shardsKey reencodedShards stor
    pure nubbedShards


verifyShard :: Shard -> Boolean
verifyShard (MkShard s) = case assetData of
    Just (MkAssetData d) -> 
        case verify d.publicKey (sha3_512 s.share) s.sig of
            Just b -> b
            Nothing -> false
    Nothing -> false

encodeShards :: Array Shard -> String
encodeShards = A.stringify <<< CA.encode (CA.array codec)

parseShards :: String -> Maybe (Array Shard)
parseShards =  (hush <<< CA.decode (CA.array codec)) <=< (hush <<< A.jsonParser)

newShard :: Effect (Maybe Shard)
newShard = do
    loc <- location =<< H.window
    s   <- hash loc
    setHash "" loc
    let params = s
    pure $ do
        decodedHashArr <- hush $ decode $ drop 1 s
        decodedHashStr <- hush $ decodeUtf8 decodedHashArr
        parsedHash     <- hush $ A.jsonParser decodedHashStr
        encodedHash    <- hush $ CA.decode codec parsedHash
        pure encodedHash




    