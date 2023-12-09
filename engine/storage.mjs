import Dexie from "https://unpkg.com/dexie@latest/dist/modern/dexie.mjs";
export default {
    init: async function(){
        const db = new Dexie("micro");
        this.db = db;
        db.version(this.version(Micro.VERSION)).stores({
            worlds: "++id,name,played",
            settings: "id",
            modules: "source"
        }).upgrade(()=>{
            //Will update saves to later versions
        });
        db.open().catch((e)=>{
            alert('IndexedDB already in use. Close any other Micro tabs.')
        });
        
        //todo: process modules
    },
    load: async function(){
        this.db.settings.each((i, c)=>{
            Micro.settings.data[c.primaryKey].value = i._value;
            console.log(i);
        })
    },
    save: async function(){
        let db = this.db;
        for(let i in Micro.settings.data){
            db.settings.put(Micro.settings.data[i]);
        }
    },
    version: function(version){
        let array = version.split('.').map((e)=>parseInt(e));
        return array[0] << 16 | array[1] << 8 | array[2];
    },
    serialize: function(){
        let serialized = {};
        Micro.modules.sendEvent('serialize', serialized);
        return serialized;
    },
    deserialize: function(object){
        Micro.modules.sendEvent('deserialize', object);
    }
}