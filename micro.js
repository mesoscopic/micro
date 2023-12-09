import * as Micro from './engine/main.mjs'
globalThis.Micro = Micro;

window.onload = async ()=>{
    await Micro.screens.switch('intro', 500);
    await Micro.storage.init();
    await Micro.modules.install('core/main.mjs');
    await Micro.modules.load('core/main.mjs');
    await Micro.storage.load();
    await Micro.utils.wait(1000);
    await document.fonts.ready;
    await Micro.utils.awaitCallback($('#enterlogo'), $.fn.animate, {height: "200vh", padding: "20vh"}, 1500);
    await Micro.screens.switch('mainmenu', 500);
    $('#enterlogo').prependTo($('#mainmenu'));
    Micro.controls.init();
    Micro.menu.init();
    await Micro.utils.awaitCallback($('#menubuttons'), $.fn.animate, {opacity: 1}, 500);
};