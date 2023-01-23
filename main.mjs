import Micro from './engine/micro.mjs'

window.Micro = Micro;

Micro.html.init();
navigator.serviceWorker.register('/micro/beta/app.js', {
  scope: "."
});
$(()=>{
  Micro.menu.build();
})