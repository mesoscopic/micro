/*
 * This module is the core of the vanilla Micro package.
 * It exposes updateTheme and player in Micro.game.
 */

import Player from './player.mjs'
import DebugLayer from './debuglayer.mjs'
import Tile from './tile.mjs'
import lightWorld from './lighting.mjs'

//Updates the theme according to the setting defined in the load event.
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
        let player = new Player([0, 0]);
        Micro.game.player = player;
        let debug;
        if(Micro.settings.data.debug.value) debug = new DebugLayer();
        Tile.fromMap(0, 0, [
            '      ▩      ',
            '     ▩□▩     ',
            '    ▩□□□▩    ',
            '   ▩□□□□□▩   ',
            '  ▩□□□□□□□▩  ',
            ' ▩□□□□□□□□□▩ ',
            '▩□□□□□□□□□□□▩',
            ' ▩□□□□□□□□□▩ ',
            '  ▩□□□□□□□▩  ',
            '   ▩□□□□□▩   ',
            '    ▩□□□▩    ',
            '     ▩□▩     ',
            '      ▩      '
        ], -2)
    }
}
export {events};