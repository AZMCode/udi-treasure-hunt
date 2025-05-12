module TreasureHunt.RootComponent.CalculateDownload(calculateDownload) where

import Prelude

import Web.File.FileReader.Aff(readAsArrayBuffer)
import Noble.Ciphers.AES.GCM(encrypt,decrypt)
import ShamirSecretSharing(split)
import Data.Traversable(traverse)
import Web.File.Blob(Blob)
import Data.Either(Either(..))
import Effect.Class(liftEffect)
import Data.ArrayBuffer.DataView(whole)
import Web.Crypto(getRandomValues)
import Effect.Aff(Aff)
import Effect.Aff.Class(liftAff)
import Run(Run,AFF,EFFECT)
import Data.ArrayBuffer.Types(Uint8Array)
import Run.Except(EXCEPT,rethrow,note,throw)
import Data.Int(fromString)
import Type.Row(type (+))
import Data.Tuple.Nested((/\),type (/\))
import Data.ArrayBuffer.Cast(toUint8Array)
import Noble.Curves.Secp256k1(randomPrivateKey,getPublicKey,sign,verify)
import Scure.Base32(encode)
import TreasureHunt.Data(AssetData(..))


calculateDownload :: Either String Blob -> String -> String -> Aff Either String Uint8Array
calculateDownload e th to = ?hole1 $ calculateDownloadMain e th to

calculateDownloadMain :: forall r. Either String Blob -> String -> String -> String -> Run (EXCEPT String + AFF + EFFECT + r) Uint8Array
calculateDownloadMain fileBlobE thresholdStr totalStr prefix = do
    file          <- (liftEffect <<< toUint8Array <<< whole) =<< (liftAff <<< readAsArrayBuffer) =<< rethrow fileBlobE
    threshold     <- (note "Umbral tiene que ser un entero" $ fromString thresholdStr)
    total         <- (note "Total tiene que ser un entero"  $ fromString totalStr    )
    when (0 >= threshold || threshold >= total) $ throw "Umbral tiene que ser un entero tal que 0 < umbral < total"
    when (1 >= total)                           $ throw "Total tiene que ser un entero tal que 1 < total"
    symmKey       <- note "No se pudo generar valores aleatorios" =<< (liftEffect $ getRandomValues 32) {- 256 bit key -}
    cyphertext    <- note "No se pudo encriptar el archivo"       =<< (liftEffect $ encrypt symmKey file)
    shares        <- note "No se pudo partir la llave en pedazos" =<< (liftAff $ split symmKey total threshold)
    privKey       <- liftEffect randomPrivateKey
    publicKey     <- note "No se pudo obtener la llave pública para firmar los pedazos" $ getPublicKey privKey
    signedShares  <- traverse (\share -> do
            let hash = ?hash share
            sig  <- note "No se pudo firmar un pedazo" $ sign privKey hash
            pure $ share /\ sig
        ) shares
    let shareUrls = (\(share /\ sig) -> do
            prefix <> "?share=" <> encode share <> "&sig=" <> encode sig
        ) <$> signedShares
    let qrs       = ?encodeToQr <$> shareUrls
        assetData = MkAssetData {
                cyphertext,
                publicKey,
                threshold
            }
    ?compressToZipAndReturn


