class MicroModule {
    constructor(module, path){
        Micro.modules.installed.push(this);
        this.module = module;
        this.loaded = false;
        this.path = path;
    }
    async send(event, ...args){
        await this.module?.events[event]?.(...args);
    }
}

export default {
    get loaded(){
        return this.installed.filter((m)=>m.loaded);
    },
    installed: [],
    sendEvent: async function(){
        for(let i in this.loaded){
            this.loaded[i].send(...arguments);
        }
    },
    install: async function(path){
        let module = await import(path);
        if(this.queryInstall(path)>-1) this.update(path, module)
        else new MicroModule(module, path);
    },
    load: async function(path){
        let index = this.queryInstall(path);
        this.installed[index].loaded = true;
        await this.installed[index].send('load');
    },
    queryInstall: function(path){
        for(let i in this.installed){
            if(this.installed[i].path===path) return i;
        }
        return -1;
    },
    update: function(path, module){
        let index = this.queryInstall(path);
        this.installed[index].module = module;
    }
}