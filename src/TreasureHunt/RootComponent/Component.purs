module TreasureHunt.RootComponent.Component(component) where

import Prelude

import Effect.Aff.Class(liftAff)
import Halogen (mkComponent, mkEval, defaultEval, modify, gets, get, Component, HalogenM) as H
import Halogen.HTML (button, progress, div, text, HTML,ClassName(ClassName)) as HH
import Halogen.HTML.Properties (classes) as HP
import Halogen.HTML.Events (onClick) as HE
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Array(length)
import Data.Maybe(Maybe(..))
import Data.Either(Either(..),blush)
import Web.File.Blob(Blob)
import Data.Tuple.Nested(type (/\),(/\))
import Effect.Aff.Class(class MonadAff)

import TreasureHunt.RootComponent.Welcome           (welcome                  )
import TreasureHunt.RootComponent.Collect           (collect                  )
import TreasureHunt.RootComponent.AdminTool         (adminTool, AdminToolState)
import TreasureHunt.RootComponent.CalculateDownload (calculateDownload        )
import TreasureHunt.Utils (Eval,emptyDiv) as U

data Page  = Welcome
                | Collect
                | DisplayS String
                | AdminTool

data State = MkState {
        shards :: Array Uint8Array,
        adminTool :: AdminToolState,
        page :: Page
    }

data Action = UpdateStored (Array Uint8Array)
            | DismissWelcome
            | Display
            | AdminSwitch
            | UploadImage (Either String Blob)
            | ChangeThreshold String
            | ChangeTotal String
            | ChangePrefix String
            | DownloadBundle



component :: forall query input output m. MonadAff m => H.Component query input output m
component = H.mkComponent { initialState, render, eval }
    where
        initialState :: input -> State
        initialState _ = MkState {
                shards: [],
                adminTool: {
                    uploadedImage: Left "Ningún archivo seleccionado",
                    threshold: "1",
                    total: "2",
                    error: Nothing,
                    prefix: "",
                    downloadLink: Nothing
                },
                page: Welcome
            }

        render :: forall w. State -> HH.HTML w Action
        render (MkState { page: Welcome         }) = welcome DismissWelcome
        render (MkState { page: Collect, shards }) = collect AdminSwitch Display $ length shards
        render (MkState { page: DisplayS  _     }) = U.emptyDiv
        render (MkState { adminTool: adminToolState, page: AdminTool       }) = 
            adminTool 
                (UploadImage <<< Left) 
                (UploadImage <<< Right) 
                ChangeThreshold
                ChangeTotal
                ChangePrefix
                DownloadBundle 
                adminToolState



        eval :: forall slots. U.Eval State query Action slots input output m
        eval = H.mkEval $ H.defaultEval { 
                handleAction = \x -> do
                    handleAction x
                    pure unit
            }
            where
                handleAction :: Action -> H.HalogenM State Action slots output m Unit
                handleAction DismissWelcome  = void $ H.modify case _ of
                    MkState r@{ page: Welcome } -> MkState $ r { page = Collect }
                    MkState r                   -> MkState $ r
                handleAction AdminSwitch     = void $ H.modify case _ of
                        MkState r@{ page: Collect   } -> MkState $ r { page = AdminTool }
                        MkState r@{ page: AdminTool } -> MkState $ r { page = Collect   }
                        MkState r                     -> MkState $ r
                handleAction (UploadImage e) = void $ H.modify case _ of
                        MkState r -> MkState $ r { adminTool { uploadedImage = e } }
                handleAction (ChangeThreshold newThreshold) = void $ H.modify case _ of
                        MkState r -> MkState $ r { adminTool { threshold = newThreshold } }
                handleAction (ChangeTotal newTotal) = void $ H.modify case _ of
                        MkState r -> MkState $ r { adminTool { total = newTotal } }
                handleAction (ChangePrefix newPrefix) = void $ H.modify case _ of
                        MkState r -> MkState $ r { adminTool { prefix = newPrefix } }
                handleAction (DownloadBundle      ) = do
                    (MkState { adminTool: { 
                            uploadedImage: uploadedImageE,
                            threshold: thresholdStr,
                            prefix,
                            total: totalStr
                        } }) <- H.get
                    e <- liftAff $ calculateDownload uploadedImageE thresholdStr totalStr prefix
                    case e of
                        Left  s -> void $ H.modify \(MkState r) -> MkState $ r { adminTool { error = Just s , downloadLink = Nothing } }
                        Right v -> void $ H.modify \(MkState r) -> MkState $ r { adminTool { error = Nothing, downloadLink = Just v  } }
                handleAction _ = pure unit
                    
                    


