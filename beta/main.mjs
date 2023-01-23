import Micro from './engine/micro.mjs'

window.Micro = Micro;

Micro.html.init();
navigator.serviceWorker.register('./app.js', {
  scope: "."
});
$(()=>{
  Micro.menu.build();
})