export const fromArray = arr => new Uint8Array(arr);

export const toArray = arr => [...arr];

export const uint8ArrayEq = a => b => {
    if (a.length !== b.length) {
        return false;
    }
    for (let i = 0; i < a.length; i++) {
        if (a[i] !== b[i]) {
            return false;
        }
    }
    return true;
}