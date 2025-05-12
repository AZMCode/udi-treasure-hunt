module TreasureHunt.Utils where

import Prelude

import Halogen.HTML (div_,HTML) as HH
import Halogen (HalogenQ, HalogenM) as H

type Eval state query action slots input output m = H.HalogenQ query action input ~> H.HalogenM state action slots output m

emptyDiv :: forall w i. HH.HTML w i
emptyDiv = HH.div_ []