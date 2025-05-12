import {base32} from "@scure/base"

export const encode = x => base32.encode(x);

export const decodeRaw = just => nothing => x => {
    try { 
        return just(base32.decode(x));
    } catch (_) {
        return nothing;
    }
};