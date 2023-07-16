const events = {
    load: (self)=>{
        console.log('Vanilla Micro got loaded');
        new Micro.settings.SettingsCategory('visuals', 'Visual Settings');
        new Micro.settings.EnumSetting('theme', 'Theme', {
            default: 'Auto',
            category: 'visuals',
            options: ['Light', 'Dark', 'Auto']
        });
        switch(Micro.settings.data.theme.value){
            case 'Light':
                $('body').addClass('light');
                break;
            case 'Dark':
                $('body').addClass('dark');
                break;
        }
    },
    buildscreen: (name)=>{
        switch(Micro.settings.data.theme.value){
            case 'Light':
                $('body').addClass('light');
                break;
            case 'Dark':
                $('body').addClass('dark');
                break;
        }
        if(name=="globalsettings"){
            console.dir(Micro.settings.categories);
            $('#globalsettings .settings').empty();
            for(let i in Micro.settings.categories){
                $('#globalsettings .settings').append("<h2>"+Micro.settings.categories[i].name+"</h2>");
                let t = $('<table></table>');
                for(let j in Micro.settings.categories[i].contents){
                    let setting = Micro.settings.categories[i].contents[j];
                    $(t).append($('<tr><td>'+setting.name+'&nbsp;&nbsp;</td></tr>').append($('<td></td>').append(setting.render())));
                }
                $('#globalsettings .settings').append(t);
            }
        }
    }
}
export {events}