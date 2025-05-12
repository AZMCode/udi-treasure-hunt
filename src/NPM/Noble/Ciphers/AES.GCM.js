import { gcm } from "@noble/ciphers/aes";
import { managedNonce } from "@noble/ciphers/webcrypto";


export const aesGcm = managedNonce(gcm);
