module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import Test.Codec.Data(testBatch) as CD

main :: Effect Unit
main = do
    log "Pruebas de Codec.Data"
    CD.testBatch

