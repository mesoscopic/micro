class MicroModule {
    constructor(module, source){
        Micro.modules.installed.push(this);
        this.module = module;
        this.loaded = false;
        this.source = source;
    }
    //Modules should export an object called 'events' in which they can define handlers for events by name.
    async send(event, ...args){
        await this.module?.events[event]?.(...args);
    }
}

export default {
    get loaded(){
        return this.installed.filter((m)=>m.loaded);
    },
    installed: [],
    //sends an event to all modules. the first argument is the event name.
    sendEvent: async function(){
        for(let i in this.loaded){
            this.loaded[i].send(...arguments);
        }
    },
    //Creates a full URL from a string or file source.
    resolveSource: function(source){
        if(typeof source == 'string'){
            return new URL(source, location);
        } else if (source instanceof File){
            return URL.createObjectURL(source);
        }
    },
    //Imports a module.
    install: async function(source){
        let resolved = this.resolveSource(source);
        let module = await import(resolved+'?'+Date.now());
        if(this.queryInstall(source)>-1) this.update(source, module)
        else new MicroModule(module, source);
    },
    //Loads an imported module by broadcasting the 'load' event.
    load: async function(source){
        let index = this.queryInstall(source);
        this.installed[index].loaded = true;
        await this.installed[index].send('load', this.installed[index]);
    },
    //Returns the index of the module, or -1 if it is not installed.
    queryInstall: function(source){
        for(let i in this.installed){
            if(this.installed[i].source===source) return i;
        }
        return -1;
    },
    //Replaces the code of a module with another.
    update: function(source, module){
        let index = this.queryInstall(source);
        this.installed[index].module = module;
    }
}