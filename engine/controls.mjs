export default {
    controls: {
        'Escape': [()=>{$('section#'+Micro.screens.active+' .escape').click();}]
    },
    _up: {},
    init: function(){
        $(document).keydown((e)=>{
            for(let i in this.controls){
                if(e.key==i){
                    this.controls[i].forEach((e)=>e(new Promise((res, rej)=>{
                        this._up[i] = this._up[i]??[];
                        this._up[i].push(res);
                    })));
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
    registerControl: function(key, callback){
        this.controls[key] = this.controls[key]??[];
        this.controls[key].push(callback);
        let s = Symbol();
        callback.id = s;
        return s;
    },
    relinquishKey: function(key, s){
        if(!this.controls[key]) return;
        this.controls[key]=this.controls[key].filter((e)=>{e.id!=s});
    }
}