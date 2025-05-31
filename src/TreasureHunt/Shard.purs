module TreasureHunt.Shard where

import Prelude

import Data.Codec.Argonaut(int,record,object,JsonCodec) as CA
import Data.Codec.Argonaut.Record(record) as CAR
import Data.ArrayBuffer.Types(Uint8Array)
import Data.ArrayBuffer.Custom(uint8ArrayCodec,uint8ArrayEq)
import Data.Profunctor(dimap)

data Shard = MkShard {
        share :: Uint8Array,
        sig :: Uint8Array
    }

instance shardEq :: Eq Shard where
    eq (MkShard x) (MkShard y) = 
        (uint8ArrayEq x.share y.share) &&
        (uint8ArrayEq x.sig   y.sig  )

codec :: CA.JsonCodec Shard
codec = dimap unShard MkShard $ CA.object "Shard" $
    CAR.record {
        share: uint8ArrayCodec,
        sig: uint8ArrayCodec
    }
    where
        unShard (MkShard x) = x

shardsKey :: String
shardsKey = "shards"