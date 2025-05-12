module TreasureHunt.RootComponent.Collect(collect) where

import Prelude

import Data.Maybe(Maybe(..),isNothing)

import Halogen.HTML (div,button,text,p_,h3,h1,ClassName(ClassName),HTML) as HH
import Halogen.HTML.Properties (classes) as HP
import Halogen.HTML.Events (onClick) as HE

import TreasureHunt.Data(assetData,AssetData(..))

collect :: forall w action. action -> action -> Int -> HH.HTML w action
collect switchAdmin display count = 
    HH.div [
            HP.classes [
                    HH.ClassName "is-flex",
                    HH.ClassName "is-flex-direction-column",
                    HH.ClassName "is-align-items-center",
                    HH.ClassName "is-justify-content-center",
                    HH.ClassName "p-5"
                ]
        ] (case assetData of
                Just (MkAssetData { threshold }) -> join $ [
                        [
                            HH.h3 [ 
                                    HP.classes [ HH.ClassName "is-size-3" ] 
                                ] [ HH.text $ "Recolección de Fragmentos" ],
                            HH.p_    [ HH.text $ "Para desbloquear el secreto, es necesario recolectar " <> show threshold <> " secretos."],
                            HH.p_    [ HH.text $ "Actualmente has recolectado " <> show count <> " de ellos." ],
                            HH.h1 [
                                    HP.classes [
                                            HH.ClassName "p-5",
                                            HH.ClassName "is-size-1"
                                        ]
                                ] [ HH.text $ show count <> "/" <> show threshold ]
                        ],
                        if   threshold == count
                        then [ 
                                HH.button [ 
                                        HE.onClick \_ -> display,
                                        HP.classes [
                                                HH.ClassName "button",
                                                HH.ClassName "is-primary"
                                            ]
                                    ] [ HH.text "Mostrar Secreto" ] 
                            ]
                        else []
                    ]
                Nothing -> [
                        HH.button [
                                HP.classes [
                                        HH.ClassName "button",
                                        HH.ClassName "is-secondary",
                                        HH.ClassName "my-5"
                                    ],
                                HE.onClick \_ -> switchAdmin
                            ] [
                                HH.text "Cambiar a Modo Admin"
                            ],
                        HH.h3 [
                                HP.classes [
                                        HH.ClassName "is-size-3"
                                    ]
                            ] [ HH.text "Ésta aplicación todavía no ha sido configurada. Por favor contacte al administrador." ]
                    ]
            )