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
        let input = $(`<span class="toggleslider"><input type="checkbox" class="setting" ${self.value?'checked':''}></span>`);
        $(input).change(()=>{
            self.value = input.get(0).checked;  
        });
        return input;
    }
    get value(){
        return this._value;
    }
    set value(val){
        this._value = !!val;
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
    SettingsCategory
}