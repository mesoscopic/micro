class Setting {
    _value;
    constructor(id, name, settings){
        this.name = name;
        this.default = settings.default;
        this.value = settings.default;
        this.category = settings.category;
        Micro.settings.data[id] = this;
        Micro.settings.category(this.category).contents.splice(settings.order??Micro.settings.category(this.category).contents.length, 0, this);
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
    constructor(id, name, settings){
        super(id, name, settings);
    }
    render(){
        let self = this;
        let input = $(`<input type="text" class="setting" value="${self.value}">`);
        $(input).attr('size', ($(input).val().length - 1)<1?1:($(input).val().length - 1));
        $(input).on('input', ()=>{
            self.value = $(input).val();
            $(input).attr('size', ($(input).val().length - 1)<1?1:($(input).val().length - 1));
        });
        return input;
    }
    get value(){
        return this._value;
    }
    set value(val){
        this._value = val;
    }
}
class NumberSetting extends Setting {
    constructor(id, name, settings){
        super(id, name, settings);
    }
    render(){
        let self = this;
        let input = $(`<input type="number" class="setting" value="${self.value}">`);
        $(input).css('width', (($(input).val().length)>1?(2+$(input).val().length):3)+'ch');
        $(input).on('input', ()=>{
            self.value = $(input).val();
            $(input).css('width', (($(input).val().length)>1?(2+$(input).val().length):3)+'ch');
        });
        return input;
    }
    get value(){
        return this._value;
    }
    set value(val){
        this._value = Number(val)??0;
    }
}
class ToggleSetting extends Setting {
    constructor(id, name, settings){
        super(id, name, settings);
    }
    render(){
        let self = this;
        let input = $(`<div class="toggleslider"></div><input type="checkbox" class="setting" ${self.value?'checked':''}>`);
        $(input).get(1).onchange=()=>{
            self.value = input.get(1).checked;  
        };
        return input;
    }
    get value(){
        return this._value;
    }
    set value(val){
        this._value = !!val;
    }
}
class EnumSetting extends Setting {
    constructor(id, name, settings){
        super(id, name, settings);
        this.options = settings.options;
    }
    render(){
        let self = this;
        let input = $(`<input type="button" value="${self.value}">`);
        $(input).click(()=>{
            self.value = self.options[self.options.indexOf(self.value)+1]??self.options[0];
        });
        return input;
    }
    get value(){
        return this._value;
    }
    set value(val){
        if(this.options.includes(val)) this._value = val;
        else throw `"${val}" is not a valid value for this enum`;
    }
}
class SettingsCategory {
    constructor(id, name, order){
        this.id = id;
        this.name = name;
        this.contents = [];
        Micro.settings.categories.splice(order??Micro.settings.categories.length, 0, this);
    }
}

export default {
    data: {},
    categories: [],
    category: function(id){
        return this.categories.filter((e)=>e.id==id)[0];
    },
    Setting,
    TextSetting,
    NumberSetting,
    ToggleSetting,
    EnumSetting,
    SettingsCategory
}