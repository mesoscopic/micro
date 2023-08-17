import Player from './player.mjs'
import DebugLayer from './debuglayer.mjs'

function updateTheme(){
    switch(Micro.settings.data.theme.value){
        case 'Light':
            $('body').addClass('light');
            break;
        case 'Dark':
            $('body').addClass('dark');
            break;
        default:
            $('body').attr('class', '');
    }
}

$.extend(Micro.game, {updateTheme});

const events = {
    load: (self)=>{
        console.log('Vanilla Micro got loaded');
        new Micro.settings.SettingsCategory('visuals', 'Visual Settings');
        new Micro.settings.EnumSetting('theme', 'Theme', {
            default: 'Auto',
            category: 'visuals',
            options: ['Light', 'Dark', 'Auto']
        });
        new Micro.settings.ToggleSetting('debug', 'Show debug overlay', {
            default: false,
            category: 'visuals'
        });
        updateTheme();
    },
    buildscreen: (name)=>{
        updateTheme();
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
        if(name=="worldselect"){
            alert('I am too lazy to add this i\'m getting right into gameplay :)');
            Micro.screens.switch('game');
            Micro.modules.sendEvent('play');
        }
    },
    play: ()=>{
        Micro.render.init();
        let player = new Player('◈', [0, 0]);
        Micro.game.player = player;
        if(Micro.settings.data.debug.value) new DebugLayer();
    }
}
export {events};