import path from "path";
import { patchCssModules } from 'vite-css-modules'

export default {
    plugins: [
        patchCssModules()
    ],
    resolve: {
        alias: [
            { find: "#ps"    , replacement: path.resolve(__dirname,"output") },
            { find: "#css"   , replacement: path.resolve(__dirname,"css"   ) },
            { find: "#assets", replacement: path.resolve(__dirname,"assets") }
        ]
    },
    build: {
        outDir: './dist-test/',
        lib: {
            entry: path.resolve(__dirname, 'test-index.js'),
            name: "udi-treasure-hunt-test",
            fileName: "udi-treasure-hunt-test",
            formats: [ "cjs" ]
        }
    },
    css: {
        modules: {
            localsConvention: 'camelCaseOnly'
        }
    }
}