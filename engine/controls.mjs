export default {
    //An object containing all currently defined keybinds and their handlers.
    controls: {
        'Escape': [()=>{$('section#'+Micro.screens.active+' .escape').click();}]
    },
    _up: {},
    mouseX: 0, 
    mouseY: 0,
    //Initiates key capturing.
    init: function(){
        $(document).keydown((e)=>{
            for(let i in this.controls){
                if(e.code==i){
                    this.controls[i].forEach((f)=>{
                        if(f.prevent || f.disabled) return;
                        if(!f.allowRepeat) f.prevent = true;
                        f(new Promise((res, rej)=>{
                            this._up[i] = this._up[i]??[];
                            this._up[i].push(()=>{res();f.prevent = false;});
                        }))
                    });
                }
            }
        })
        $(document).keyup((e)=>{
            for(let i in this._up){
                if(e.code==i){
                    this._up[i].forEach((e)=>e());
                    delete this._up[i];
                }
            }
        })
        // The special codes LMB, RMB, and MMB correspond to the Left, Right, and Middle mouse buttons instead of keys
        $(document).mousedown((e)=>{
            for(let i in this.controls){
                if(e.button == 0 && i == "LMB" || e.button == 1 && i == "MMB" || e.button == 2 && i == "RMB"){
                    this.controls[i].forEach((f)=>{
                        if(f.disabled) return;
                        f(new Promise((res, rej)=>{
                            this._up[i] = this._up[i]??[];
                            this._up[i].push(res);
                        }))
                    });
                }
            }
        });
        $(document).mouseup((e)=>{
            for(let i in this._up){
                if(e.button == 0 && i == "LMB" || e.button == 1 && i == "MMB" || e.button == 2 && i == "RMB"){
                    this._up[i].forEach((e)=>e());
                    delete this._up[i];
                }
            }
        })
        $(document).mousemove((e)=>{
            Micro.controls.mouseX = e.clientX;
            Micro.controls.mouseY = e.clientY;
        })
    },
    //Attaches a callback to a keydown event. There can be more than one callback per key.
    //Each callback is passed a Promise that resolves when the key is released.
    //This function returns a Symbol that can be used to stop handling this key.
    registerControl: function(key, callback, allowRepeat){
        this.controls[key] = this.controls[key]??[];
        this.controls[key].push(callback);
        let s = Symbol();
        callback.id = s;
        callback.allowRepeat = allowRepeat ?? true;
        return s;
    },
    //Stops handling a key press using the Symbol returned by registerControl.
    relinquishKey: function(key, s){
        if(!this.controls[key]) return;
        this._up[key]?.forEach?.((e)=>e());
        this.controls[key]=this.controls[key].filter((e)=>e.id!=s);
    },
    //Temporarily disables a handler.
    disable: function(key, s){
        this.controls[key].filter((e)=>e.id==s)[0].disabled = true;
    },
    //Re-enables a handler.
    enable: function(key, s){
        this.controls[key].filter((e)=>e.id==s)[0].disabled = false;
    }
}