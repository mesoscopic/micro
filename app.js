self.addEventListener('install', function(event){
  self.skipWaiting();
});
self.addEventListener('fetch', function(event) {
  event.respondWith(async function() {
    try{
      var res = await fetch(event.request);
      var cache = await caches.open('cache');
      cache.put(event.request.url, res.clone());
      return res;
    }
    catch(error){
      var cache = await caches.open('cache');
      return await cache.match(event.request.url);
    }
  }());
});