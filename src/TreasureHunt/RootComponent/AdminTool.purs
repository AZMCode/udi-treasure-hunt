module TreasureHunt.RootComponent.AdminTool(adminTool, AdminToolState) where

import Prelude

import Halogen.HTML (div, text, input, button, p_, a, h3,label_, ClassName(ClassName), HTML) as HH
import Halogen.HTML.Events(onFileUpload,onValueInput,onClick) as HE
import Halogen.HTML.Properties (classes,type_,value,accept,placeholder,href,download) as HP
import DOM.HTML.Indexed.InputType (InputType(..))
import DOM.HTML.Indexed.InputAcceptType(InputAcceptType(..),InputAcceptTypeAtom(..))
import Data.MediaType(MediaType(..))
import Data.Maybe(Maybe(..))
import Data.Either(Either(..))
import Data.Array(head)
import Data.Int(fromString)
import Web.File.Blob(Blob)
import Web.File.File(File,toBlob)

type AdminToolState = {
        uploadedImage :: Either String File,
        threshold     :: String,
        total         :: String,
        error         :: Maybe String,
        prefix        :: String,
        downloadLink  :: Maybe String
    }

type AdminActions action = {
        uploadErr       :: String -> action,
        upload          :: File   -> action,
        changeThreshold :: String -> action,
        changeTotal     :: String -> action,
        changePrefix    :: String -> action,
        download        ::           action
    }

adminTool :: forall w action. AdminActions action -> AdminToolState -> HH.HTML w action
adminTool actions state =
    HH.div [
            HP.classes [
                    HH.ClassName "p-5"
                ]
        ] [
            HH.h3 [
                    HP.classes [
                            HH.ClassName "is-size-3"
                        ]
                ] [ HH.text "Modo Admin" ],
            HH.input [ 
                    HP.accept $ InputAcceptType $ [ AcceptMediaType $ MediaType "image/*" ],
                    HP.type_ InputFile,
                    HP.classes [
                        HH.ClassName "input",
                        HH.ClassName "is-secondary"
                    ],
                    HE.onFileUpload $ \fs -> case head fs of
                        Just f  -> actions.upload    $ f
                        Nothing -> actions.uploadErr $ "No hay archivo que subir"
                ],
            case state.uploadedImage of
                Left err -> HH.p_ [ HH.text err ]
                Right _  -> HH.p_ [ HH.text "Archivo Exitosamente Seleccionado" ],
            HH.label_ [
                    HH.text "Umbral",
                    HH.input [
                        HP.classes [ HH.ClassName "input" ],
                        HP.type_ InputNumber,
                        HP.value state.threshold,
                        HE.onValueInput actions.changeThreshold
                    ]
                ],
            HH.label_ [
                    HH.text "Total",
                    HH.input [
                        HP.classes [ HH.ClassName "input" ],
                        HP.type_ InputNumber,
                        HP.value state.total,
                        HE.onValueInput actions.changeTotal
                    ]
                ],
            HH.label_ [
                    HH.text "Prefijo",
                    HH.input [
                        HP.classes [ HH.ClassName "input" ],
                        HP.type_ InputText,
                        HP.value state.prefix,
                        HE.onValueInput actions.changePrefix
                    ]
                ],
            HH.p_ [ 
                    HH.text 
                        case state.error of
                            Just s -> s
                            Nothing -> ""
                ],
            HH.button [
                    HP.classes [
                        HH.ClassName "button",
                        HH.ClassName "is-primary",
                        HH.ClassName "m-5"
                    ],
                    HE.onClick \_ -> actions.download
                ] [
                    HH.text "Generate Config Files"
                ],
            HH.a (case state.downloadLink of
                    Just link -> [
                            HP.classes [
                                HH.ClassName "button",
                                HH.ClassName "is-primary"
                            ],
                            HP.href link
                        ]
                    Nothing -> [
                        HP.classes [
                            HH.ClassName "is-disabled"
                        ]
                    ]
                ) [
                    HH.text "Download Link"
                ]
        ]
