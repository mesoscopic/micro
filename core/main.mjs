const events = {
    load: (self)=>{
        console.log('Vanilla Micro got loaded');
        new Micro.settings.SettingsCategory('debug', 'Debug Settings');
        new Micro.settings.NumberSetting('imaginary', 'Imagine a setting here', {
            default: 1,
            category: 'debug'
        });
    },
    buildscreen: (name)=>{
        if(name=="globalsettings"){
            console.dir(Micro.settings.categories);
        }
    }
}
export {events}