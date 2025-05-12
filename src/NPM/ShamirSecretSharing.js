import {split, combine} from 'shamir-secret-sharing';

export const splitRaw = just => nothing => secret => total => threshold => async () => {
    try {
        return just(await split(secret,total,threshold))
    } catch {
        return nothing;
    }
};

export const combineRaw = just => nothing => shares => async () => {
    try {
        return just(await combine(shares))
    } catch {
        return nothing;
    }
};