import path from "path";
import { patchCssModules } from 'vite-css-modules'

export default {
    plugins: [
        patchCssModules()
    ],
    resolve: {
        alias: [
            { find: "@ps"    , replacement: path.resolve(__dirname,"output") },
            { find: "@css"   , replacement: path.resolve(__dirname,"css"   ) },
            { find: "@assets", replacement: path.resolve(__dirname,"assets") }
        ]
    },
    css: {
        modules: {
            localsConvention: 'camelCaseOnly'
        }
    }
}