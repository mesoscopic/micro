import * as Micro from './engine/main.mjs'
globalThis.Micro = Micro;

$(async ()=>{
    await Micro.screens.switch('intro', 500);
    await Micro.utils.wait(1000);
    await Micro.utils.awaitCallback($('#enterlogo'), $.fn.show, 1500);
});