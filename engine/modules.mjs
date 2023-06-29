class MicroModule {
    constructor(module, path){
        Micro.modules.installed.push(this);
        this.module = module;
        this.loaded = false;
        this.source = source;
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
    resolveSource: function(source){
        if(typeof source == 'string'){
            return new URL(source, location);
        } else if (source instanceof File){
            return URL.createObjectURL(source);
        }
    },
    install: async function(source){
        let resolved = this.resolveSource(source);
        let module = await import(resolved);
        if(this.queryInstall(source)>-1) this.update(source, module)
        else new MicroModule(module, source);
    },
    load: async function(source){
        let index = this.queryInstall(source);
        this.installed[index].loaded = true;
        await this.installed[index].send('load');
    },
    queryInstall: function(source){
        for(let i in this.installed){
            if(this.installed[i].source===source) return i;
        }
        return -1;
    },
    update: function(source, module){
        let index = this.queryInstall(source);
        this.installed[index].module = module;
    }
}