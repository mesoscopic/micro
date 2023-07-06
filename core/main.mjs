const events = {
    load: (self)=>{
        console.log('Vanilla Micro got loaded');
        Micro.settings.register('imaginary', new Micro.settings.NumberSetting('Imagine a setting here', 1));
    }
}
export {events}