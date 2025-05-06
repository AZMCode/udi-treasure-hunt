module TreasureHunt.Utils where

import Prelude

import Halogen (HalogenQ, HalogenM) as H

type Eval state action slots query input output m = H.HalogenQ query action input ~> H.HalogenM state action slots output m