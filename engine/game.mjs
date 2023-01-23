import World from '../modules/world.mjs'

const game = {
  start: function(id, packs){
    window.world = this.active = new World(id);
    if(!window.trailer) music.init();
    for(var i in packs){
      this.package.import(packs[i]);
    }
  },
  package: {
    import: async function(url){
      let pack = await import(url);
      
    }
  }
}

export default game;