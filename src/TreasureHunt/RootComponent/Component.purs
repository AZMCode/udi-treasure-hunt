module TreasureHunt.RootComponent.Component(component) where

import Prelude

import Effect.Aff.Class(liftAff)
import Effect.Class(liftEffect)
import Halogen (mkComponent, mkEval, defaultEval, modify, gets, get, put, Component, HalogenM) as H
import Halogen.HTML (button, progress, div, text, p_, img, HTML,ClassName(ClassName)) as HH
import Halogen.HTML.Properties (classes,src) as HP
import Halogen.HTML.Events (onClick) as HE
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Array(length)
import Data.Maybe(Maybe(..))
import Data.Either(Either(..),blush,note)
import Web.File.Blob(Blob)
import Web.File.File(File)
import Data.Tuple.Nested(type (/\),(/\))
import Effect.Aff.Class(class MonadAff)
import Data.TextDecoder(decodeUtf8) as T
import Data.Bifunctor(lmap)

import TreasureHunt.RootComponent.Welcome           (welcome                  )
import TreasureHunt.RootComponent.Collect           (collect                  )
import TreasureHunt.RootComponent.AdminTool         (adminTool, AdminToolState)
import TreasureHunt.RootComponent.CalculateDownload (calculateDownload        )
import TreasureHunt.RootComponent.Initialize        (initialize               )
import TreasureHunt.RootComponent.Decode            (decode                   )
import TreasureHunt.RootComponent.Display           (display                  )
import TreasureHunt.Shard                           (Shard                    )
import TreasureHunt.Utils (Eval,emptyDiv) as U

data Page  = Welcome
                | Collect
                | DisplayS 
                | AdminTool

data State = MkState {
        shards :: Array Shard,
        adminTool :: AdminToolState,
        page :: Page,
        decryptedData :: (Either String String)
    }

data Action = Initialize
            | DismissWelcome
            | Display
            | AdminSwitch
            | UploadImage (Either String File)
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
                decryptedData: Left "Datos no decriptados todavía. Refresque e intente de nuevo.",
                page: Welcome
            }

        render :: forall w. State -> HH.HTML w Action
        render (MkState { page: Welcome                 }) = welcome DismissWelcome
        render (MkState { page: Collect, shards         }) = collect AdminSwitch Display $ length shards
        render (MkState { page: DisplayS, decryptedData }) = display Display decryptedData
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
                handleAction = handleAction,
                initialize = Just Initialize
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
                handleAction Initialize = do
                    initialShards <- liftEffect $ initialize
                    void $ H.modify \(MkState r) -> MkState $ r { shards = initialShards }
                handleAction Display    = do
                    s <- H.get 
                    let (MkState r@{ page, shards, decryptedData }) = s
                    case page /\ decryptedData of
                        Collect  /\ (Left  _) -> do
                            decodedUrlE <- liftAff $ decode shards
                            void $ H.put $ MkState $ r { page = DisplayS, decryptedData = decodedUrlE }
                        Collect  /\ (Right s) -> 
                            void $ H.put $ MkState $ r { page = DisplayS }
                        DisplayS /\ _         ->
                            void $ H.put $ MkState $ r { page = Collect   }
                        _                     -> pure unit


                
                    
                    


