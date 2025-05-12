export const encryptRaw = just => nothing => managedCipher => key => data => () => {
    try {
        return just(managedCipher(key).encrypt(data));
    } catch {
        return nothing;
    }
};

export const decryptRaw = just => nothing => managedCipher => key => data => {
    try {
        return just(managedCipher(key).decrypt(data));
    } catch {
        return nothing;
    }
}