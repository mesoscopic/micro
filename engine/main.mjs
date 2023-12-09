//Re-exports all modules as Micro.*
const VERSION = '0.1.0.14'
export {default as screens} from './screens.mjs'
export {default as utils} from './utils.mjs'
export {default as modules} from './modules.mjs'
export {default as menu} from './menu.mjs'
export {default as controls} from './controls.mjs'
export {default as settings} from './settings.mjs'
export {default as render} from './render.mjs'
let game = {}, common = {classes: {}};
common.classes["core:Character"] = render.Character;
export {game, common}
export {default as storage} from './storage.mjs'
export {VERSION}