module Test.Codec.Data(testBatch) where

import Prelude

import Effect(Effect)
import Data.Maybe(Maybe(..))
import TreasureHunt.Data(codec,AssetData)
import Data.Argonaut (jsonParser,stringify)
import Data.Either (hush)
import Data.Codec.Argonaut (encode, decode)
import Test.QuickCheck (quickCheck,assertEquals,Result)
import Test.QuickCheck.Gen(Gen)

import Prelude

codecTest :: AssetData -> Gen Result
codecTest d = pure $ assertEquals (Just d) (
        let encoded = stringify $ encode codec d
            decoded = (hush <<< decode codec) =<< (hush $ jsonParser encoded)
        in  decoded
    )

testBatch :: Effect Unit
testBatch = quickCheck codecTest