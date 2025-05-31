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

adminTool :: forall w action. (String -> action) -> (File -> action) -> (String -> action) -> (String -> action) -> (String -> action) -> action -> AdminToolState -> HH.HTML w action
adminTool uploadErr upload changeThreshold changeTotal changePrefix download ({ uploadedImage, threshold, total, prefix, error: formErr, downloadLink }) =
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
                        Just f  -> upload    $ f
                        Nothing -> uploadErr $ "No hay archivo que subir"
                ],
            case uploadedImage of
                Left err -> HH.p_ [ HH.text err ]
                Right _  -> HH.p_ [ HH.text "Archivo Exitosamente Seleccionado" ],
            HH.label_ [
                    HH.text "Umbral",
                    HH.input [
                        HP.classes [ HH.ClassName "input" ],
                        HP.type_ InputNumber,
                        HP.value threshold,
                        HE.onValueInput changeThreshold
                    ]
                ],
            HH.label_ [
                    HH.text "Total",
                    HH.input [
                        HP.classes [ HH.ClassName "input" ],
                        HP.type_ InputNumber,
                        HP.value total,
                        HE.onValueInput changeTotal
                    ]
                ],
            HH.label_ [
                    HH.text "Prefijo",
                    HH.input [
                        HP.classes [ HH.ClassName "input" ],
                        HP.type_ InputText,
                        HP.value prefix,
                        HE.onValueInput changePrefix
                    ]
                ],
            HH.p_ [ 
                    HH.text 
                        case formErr of
                            Just s -> s
                            Nothing -> ""
                ],
            HH.button [
                    HP.classes [
                        HH.ClassName "button",
                        HH.ClassName "is-primary",
                        HH.ClassName "m-5"
                    ],
                    HE.onClick \_ -> download
                ] [
                    HH.text "Generate Config Files"
                ],
            HH.a (case downloadLink of
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
