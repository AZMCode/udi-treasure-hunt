module TreasureHunt.RootComponent.Display (display) where

import Prelude

import Halogen.HTML(div,img,button,text,p,HTML,ClassName(..)) as HH
import Halogen.HTML.Properties(classes,src) as HP
import Halogen.HTML.Events(onClick) as HE
import Data.Either(Either(..))

display :: forall w action. action -> Either String String -> HH.HTML w action
display switchBack s = 
    HH.div [
            HP.classes [
                HH.ClassName "p-5",
                HH.ClassName "is-flex",
                HH.ClassName "is-flex-direction-column",
                HH.ClassName "is-align-items-center",
                HH.ClassName "is-justify-content-center"
            ]
        ] [
            HH.button [
                    HE.onClick $ \_ -> switchBack,
                    HP.classes [
                            HH.ClassName "button",
                            HH.ClassName "is-primary"
                        ]
                ] [
                    HH.text "Volver atrás"
                ],
            case s of
                Left s ->
                    HH.p [
                            HP.classes [
                                    HH.ClassName "p-5"
                                ]
                        ] [ HH.text s ]
                Right s ->
                    HH.img [ 
                            HP.src s, 
                            HP.classes [
                                    HH.ClassName "p-5"
                                ]
                        ]
        ]