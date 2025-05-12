import { secp256k1 } from '@noble/curves/secp256k1';

export const randomPrivateKey = () => secp256k1.utils.randomPrivateKey();

export const getPublicKeyRaw = just => nothing => priv => {
    try {
        return just(secp256k1.getPublicKey(priv))
    } catch (_) {
        return nothing;
    }
};

export const signRaw = just => nothing => priv => msg => {
    try {
        return just(secp256k1.sign(msg,priv).toCompactRawBytes());
    } catch {
        return nothing;
    }
};

export const verifyRaw = just => nothing => pub => msg => sig =>  {
    try {
        return just(secp256k1.verify(sig,msg,pub));
    } catch {
        return nothing;
    }
}