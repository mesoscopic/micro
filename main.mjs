import Micro from './engine/micro.mjs'

window.Micro = Micro;

Micro.html.init();
navigator.serviceWorker.register('/offline.js', {
  scope: "."
});
$(()=>{
  Micro.menu.build();
})