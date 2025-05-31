# UDI Treasure Hunt

## Descripción

UDI Treasure Hunt es una aplicación web desarrollada por un estudiante de la Universidad UDI Bolivia, diseñada como un juego de búsqueda de "huevos de pascua" (Easter Egg Hunt) en el campus. Los estudiantes o participantes deben encontrar y escanear códigos QR que contienen fragmentos de un secreto. Al reunir suficientes fragmentos válidos, se desbloquea una imagen secreta.

El proyecto utiliza **Purescript** y está construido completamente como una aplicación estática, sin backend, garantizando seguridad y privacidad incluso frente a ingeniería inversa.

## Características principales

- **Juego de búsqueda de secretos:** Encuentra QRs escondidos en el campus, escanéa y almacena fragmentos.
- **Desbloqueo seguro:** Solo al reunir la cantidad mínima (umbral) de fragmentos válidos, se revela el contenido secreto.
- **Validación criptográfica:** Cada fragmento está firmado digitalmente y es validado localmente para evitar fraudes.
- **Privacidad local:** Los fragmentos recolectados se almacenan solo en el dispositivo que los escanea.
- **Interfaz de administración:** Los administradores pueden cargar la imagen secreta, definir el umbral, generar QRs y descargar la configuración.
- **100% estática:** Sin servidores, usando sólo código de cliente. Puede desplegarse en GitHub Pages, Netlify, Vercel, etc.
- **Funcionalidad multiplataforma:** Usable desde navegadores de escritorio y móviles.

## Instalación y despliegue

### Requisitos

- Node.js (>=14)
- npm
- [Purescript](https://www.purescript.org/)
- [Spago](https://github.com/purescript/spago)
- Cualquier servidor estático (opcional para pruebas locales)

### Instalación

```bash
git clone https://github.com/AZMCode/udi-treasure-hunt.git
cd udi-treasure-hunt
npm install
npm run build
```

### Ejecución en desarrollo

Puedes utilizar un servidor estático o alguna herramienta como `live-server` o `serve` de npm:

```bash
npx build:watch .
```

### Despliegue

Para despliegue, simplemente sube el contenido generado a cualquier hosting estático (ej: GitHub Pages, Netlify, Vercel).

## Uso

### Como participante

1. Abre la aplicación en tu navegador (móvil o escritorio).
2. Escanea los QRs distribuidos en el campus UDI.
3. La app almacenará fragmentos válidos en tu dispositivo.
4. Cuando completes la cantidad mínima de fragmentos (umbral), podrás ver el contenido secreto.

### Como administrador

1. Accede a la interfaz de administración desde la app.
2. Sube la imagen secreta a revelar.
3. Define el umbral (cantidad mínima de fragmentos) y el total de fragmentos a generar.
4. Descarga los QRs y distribúyelos físicamente.
5. Comparte la app con los participantes.

## Seguridad

- Los fragmentos son generados usando **Shamir Secret Sharing** y firmados digitalmente con claves ECDSA.
- El secreto (imagen) es cifrado con **AES-GCM** y sólo puede ser descifrado localmente con los fragmentos válidos.
- La validación de fragmentos es completamente local y resistente a ingeniería inversa.
- Ningún dato de usuario es compartido entre dispositivos ni enviado a servidores.

## Estructura del repositorio

```
src/
 └── Main.purs
 └── TreasureHunt/
       └── RootComponent/
             ├── Component.purs
             ├── Welcome.purs
             ├── Collect.purs
             ├── AdminTool.purs
             ├── CalculateDownload.purs
             ├── Decode.purs
             └── Display.purs
       └── Shard.purs
 └── NPM/
       ├── ShamirSecretSharing.js
       ├── Noble/
             ├── Curves/Secp256k1.js
             ├── Ciphers/AES.GCM.js
             └── Ciphers/WebCrypto.ManagedNonce.js
       └── Web.Crypto.js
index.js
```

## Dependencias principales

- [Purescript](https://www.purescript.org/)
- [Halogen](https://github.com/purescript-halogen/purescript-halogen)
- [shamir-secret-sharing (NPM)](https://www.npmjs.com/package/shamir-secret-sharing)
- [@noble/curves](https://www.npmjs.com/package/@noble/curves)
- [@noble/ciphers](https://www.npmjs.com/package/@noble/ciphers)

## Créditos

Desarrollado por [AZMCode](https://github.com/AZMCode).

## Licencia

MIT

---

**¡Que empiece la caza!**
