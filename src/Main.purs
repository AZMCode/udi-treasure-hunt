module Main where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Halogen.Aff (awaitBody,runHalogenAff) as HA
import Halogen.VDom.Driver (runUI)
import TreasureHunt.RootComponent.Component (component)
import TreasureHunt.Data(assetData)
import Debug

main :: Effect Unit
main = HA.runHalogenAff mainAff

mainAff :: Aff Unit
mainAff = do
    launchHalogen

launchHalogen :: Aff Unit
launchHalogen = void $ HA.awaitBody >>= runUI component unit