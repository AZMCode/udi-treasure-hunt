module TreasureHunt.RootComponent.CalculateDownload(calculateDownload) where

import Prelude

import Web.File.FileReader.Aff(readAsArrayBuffer)
import Noble.Ciphers.AES.GCM(encrypt,decrypt)
import ShamirSecretSharing(split)
import Data.Traversable(traverse)
import Web.File.File(File,toBlob)
import Web.File.Blob(Blob,type_,fromString) as B
import Web.File.Url(createObjectURL)
import Data.Either(Either(..))
import Effect.Class(liftEffect)
import Data.ArrayBuffer.DataView(whole)
import Data.Array(foldl)
import Web.Crypto(getRandomValues)
import Effect.Aff(Aff)
import Effect.Aff.Class(liftAff)
import Run(Run,AFF,EFFECT,runBaseAff')
import Data.ArrayBuffer.Types(Uint8Array)
import Run.Except(EXCEPT,rethrow,note,throw,runExcept)
import Data.Int(fromString)
import Type.Row(type (+))
import Data.Tuple.Nested((/\),type (/\))
import Data.ArrayBuffer.Cast(toUint8Array)
import Noble.Curves.Secp256k1(randomPrivateKey,getPublicKey,sign)
import Noble.Hashes.SHA3(sha3_512)
import TreasureHunt.Data(AssetData(..),assetDataToJSON)
import QRCode(toDataURL)
import Data.Binary.Base64(encodeUrl)
import Data.String.Base64(encodeUrl) as S
import Data.MediaType(MediaType(MediaType))
import Data.Codec.Argonaut(encode) as CA
import Data.Argonaut(stringify) as A
import Data.TextEncoder(encode) as T
import TreasureHunt.Shard(Shard(..),codec)

calculateDownload :: Either String File -> String -> String -> String -> Aff (Either String String)
calculateDownload e th to prefix = runBaseAff' $ runExcept $ calculateDownloadMain e th to prefix

calculateDownloadMain :: forall r. Either String File -> String -> String -> String -> Run (EXCEPT String + AFF + EFFECT + r) String
calculateDownloadMain fileE thresholdStr totalStr urlPrefix = do
    blob          <- toBlob <$> rethrow fileE
    fileArr       <- (liftEffect <<< toUint8Array <<< whole) =<< (liftAff $ readAsArrayBuffer blob)
    threshold     <- (note "Umbral tiene que ser un entero" $ fromString thresholdStr)
    total         <- (note "Total tiene que ser un entero"  $ fromString totalStr    )
    when (0 >= threshold || threshold >= total) $ throw "Umbral tiene que ser un entero tal que 0 < umbral < total"
    when (1 >= total)                           $ throw "Total tiene que ser un entero tal que 1 < total"
    symmKey       <- note "No se pudo generar valores aleatorios" =<< (liftEffect $ getRandomValues 32) {- 256 bit key -}
    cyphertext    <- note "No se pudo encriptar el archivo"       =<< (liftEffect $ encrypt symmKey fileArr)
    shares        <- note "No se pudo partir la llave en pedazos" =<< (liftAff $ split symmKey total threshold)
    privKey       <- liftEffect randomPrivateKey
    publicKey     <- note "No se pudo obtener la llave pública para firmar los pedazos" $ getPublicKey privKey
    let assetDataStr = assetDataToJSON $ MkAssetData {
            cyphertext,
            publicKey,
            threshold,
            total
        }
        assetDataB64 = S.encodeUrl assetDataStr
    signedShares  <- traverse (\share -> do
            let hash = sha3_512 share
            sig  <- note "No se pudo firmar un pedazo" $ sign privKey hash
            pure $ MkShard { share, sig }
        ) shares
    let shareUrls = (((urlPrefix <> "#") <> _) <<< encodeUrl <<< T.encode <<< A.stringify <<< CA.encode codec) <$> signedShares
    qrs <- traverse (note "No se pudo codificar un pedazo como qr") =<< traverse (liftAff <<< toDataURL) shareUrls
    let qrPagePrefix = """
                <html>
                    <head>
                        <title> QRs para Busqueda de Secretos </title>
                        <style>
                            img {
                                width: 30vw
                            }
                        </style>
                    </head>
                    <body>
                        <div>
            """
        qrPagePostfix = 
            "</div><div><a download=\"data.json\" href=\"data:application/json;base64," <> assetDataB64 <> "\">Configuracion</a></div>" <> 
            """
                    </body>
                </html>
            """
        qrPage = (foldl 
                (\t qr -> t <> "<img src=\"" <> qr <> "\"/>\n") 
                qrPagePrefix 
                qrs
            ) <> qrPagePostfix
        qrPageBlob = B.fromString qrPage (MediaType "text/html")
    qrPageUrl <- liftEffect $ createObjectURL qrPageBlob
    pure qrPageUrl
        


