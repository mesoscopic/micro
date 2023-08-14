export default {
    controls: {
        'Escape': [()=>{$('section#'+Micro.screens.active+' .escape').click();}]
    },
    _up: {},
    init: function(){
        $(document).keydown((e)=>{
            for(let i in this.controls){
                if(e.key==i){
                    this.controls[i].forEach((f)=>{
                        if(f.disabled) return;
                        if(!f.allowRepeat) f.disabled = true;
                        f(new Promise((res, rej)=>{
                            this._up[i] = this._up[i]??[];
                            this._up[i].push(()=>{res();f.disabled = false;});
                        }))
                    });
                }
            }
        })
        $(document).keyup((e)=>{
            for(let i in this._up){
                if(e.key==i){
                    this._up[i].forEach((e)=>e());
                    delete this._up[i];
                }
            }
        })
    },
    registerControl: function(key, callback, allowRepeat){
        this.controls[key] = this.controls[key]??[];
        this.controls[key].push(callback);
        let s = Symbol();
        callback.id = s;
        callback.allowRepeat = allowRepeat ?? true;
        return s;
    },
    relinquishKey: function(key, s){
        if(!this.controls[key]) return;
        this.controls[key]=this.controls[key].filter((e)=>{e.id!=s});
    }
}