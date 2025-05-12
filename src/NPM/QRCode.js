import QRCode from "qrcode";

export const toDataURLRaw = just => nothing => data => async () => {
    try {
        return just(await QRCode.toDataURL(data));
    } catch {
        return nothing;
    }
};