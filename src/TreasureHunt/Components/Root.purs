module TreasureHunt.Components.Root(component) where

import Prelude

import Halogen      (mkComponent, mkEval, defaultEval, Component) as H
import Halogen.HTML (div_, text, HTML) as HH

import TreasureHunt.Utils (Eval) as U

type State = Unit

component :: forall query input output m. H.Component query input output m
component = H.mkComponent { initialState, render, eval }
    where
        initialState :: input -> State
        initialState _ = unit

        render :: forall w. State -> HH.HTML w input
        render _ = HH.div_ [ HH.text "Loaded!" ]

        eval :: forall action slots. U.Eval State action slots query input output m
        eval = H.mkEval $ H.defaultEval

