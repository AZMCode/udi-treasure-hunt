export const getRandomValuesRaw = just => nothing => size => () => {
    try {
        return just(crypto.getRandomValues(new Uint8Array(size)));
    } catch {
        return nothing;
    }
}