import * as Micro from './engine/main.mjs'
globalThis.Micro = Micro;

$(async ()=>{
    await Micro.screens.switch('intro', 500);
    await Micro.utils.awaitCallback($('#enterlogo').show, 500);
    alert('did it');
});