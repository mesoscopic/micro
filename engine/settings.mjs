class Setting {
    _value;
    constructor(name, defaultval){
        this.name = name;
        this.default = defaultval;
        this.value = defaultval;
    }
    render(){}
    get value(){
        return this._value;
    }
    set value(val){
        this._value = val;
    }
}
class TextSetting extends Setting {
    constructor(name, defaultval){
        super(name, defaultval);
    }
    render(){}
    set value(val){
        this._value = val;
    }
}
class NumberSetting extends Setting {
    constructor(name, defaultval){
        super(name, defaultval);
    }
    render(){}
    set value(val){
        this._value = Number(val)??0;
    }
}
class ToggleSetting extends Setting {
    constructor(name, defaultval){
        super(name, defaultval);
    }
    render(){}
    set value(val){
        this._value = !!val;
    }
}

export default {
    data: {},
    register: function(id, setting){
        if(!(setting instanceof Setting)) throw 'This is not a setting.';
        this.data[id] = setting;
    },
    Setting,
    TextSetting,
    NumberSetting,
    ToggleSetting
}