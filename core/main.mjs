/*
 * This module is the core of the vanilla Micro package.
 * It exposes updateTheme in Micro.common and player in Micro.game.
 */

import Player from './player.mjs'
import DebugLayer from './debuglayer.mjs'
import Tile from './tile.mjs'
import lightWorld from './lighting.mjs'
import * as setPieces from './setpieces.mjs'
import world from './world.mjs'

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
Micro.common.updateTheme = updateTheme;

function togglePause(){
    if(Micro.render.active) {
        Micro.render.stop();
        $('#pausemenu').show();
        Micro.game.player.disableControls();
    }
    else {
        Micro.render.init();
        $('.overlay').hide();
        Micro.screens.build('game');
        Micro.game.player.enableControls();
    }
}
Micro.common.togglePause = togglePause;

Micro.common.setPieces = setPieces;

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
        new Micro.settings.ToggleSetting('fill', 'Generate filler tiles', {
            default: true,
            category: 'visuals'
        })
        updateTheme();
        $('#newworld').click(()=>{
            $('.worldoptions').empty();
            Micro.screens.switch('createworld');
            Micro.modules.sendEvent('newworldscreen');
        })
        $('#playnew').click(async ()=>{
            let newWorld = {};
            Micro.modules.sendEvent('newworld', newWorld);
            newWorld.id = await Micro.storage.db.worlds.put(newWorld);
            Micro.modules.sendEvent('play', newWorld);
            Micro.screens.switch('game');
        })
    },
    buildscreen: (name)=>{
        updateTheme();
        Micro.storage.save();
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
        if(name=="gamesettings"){
            console.dir(Micro.settings.categories);
            $('#gamesettings .settings').empty();
            for(let i in Micro.settings.categories){
                $('#gamesettings .settings').append("<h2>"+Micro.settings.categories[i].name+"</h2>");
                let t = $('<table></table>');
                for(let j in Micro.settings.categories[i].contents){
                    let setting = Micro.settings.categories[i].contents[j];
                    $(t).append($('<tr><td>'+setting.name+'&nbsp;&nbsp;</td></tr>').append($('<td></td>').append(setting.render())));
                }
                $('#gamesettings .settings').append(t);
            }
        }
        if(name=="worldselect"){
            $('.worlds').empty();
            Micro.storage.db.worlds.orderBy('played').reverse().each((world)=>{
                let button = $('<button class="major">Play</button>');
                let deletebutton = $('<button>Delete</button>');
                let editbutton = $('<button>Edit</button>');
                $('.worlds').append($('<div class="save"><h3>'+world.name+'</h3></div>').append(button).append(editbutton).append(deletebutton));
                button.click(()=>{
                    Micro.modules.sendEvent('play', world);
                    Micro.screens.switch('game');
                });
                deletebutton.click(()=>{
                    Micro.storage.db.worlds.delete(world.id).then(()=>{
                        Micro.screens.build("worldselect");
                    })
                });
                editbutton.click(()=>{
                    $('.worldoptions').empty();
                    $('#saveedits').off('click');
                    Micro.modules.sendEvent('editworldscreen', world);
                    Micro.screens.switch('editworld');
                })
            })
        }
    },
    newworldscreen: () => {
        let name = $('<input type="text" id="newworldname" value="Micro World">');
        $('<p></p>').append($('<label>World name: </label>').append(name)).appendTo('#createworld .worldoptions');
        $(name).on('input', ()=>{
            $(name).attr('size', ($(name).val().length - 1)<1?1:($(name).val().length - 1));
        });
        $(name).attr('size', ($(name).val().length - 1)<1?1:($(name).val().length - 1));
    },
    editworldscreen: (world)=>{
        let name = $('<input type="text" id="editworldname" value="Micro World">');
        name.val(world.name);
        $('<p></p>').append($('<label>World name: </label>').append(name)).appendTo('#editworld .worldoptions');
        $(name).on('input', ()=>{
            $(name).attr('size', ($(name).val().length - 1)<1?1:($(name).val().length - 1));
        });
        $(name).attr('size', ($(name).val().length - 1)<1?1:($(name).val().length - 1));

        $('#saveedits').click(async ()=>{
            let changes = {};
            Micro.modules.sendEvent('editworld', changes);
            await Micro.storage.db.worlds.update(world.id, changes);
            Micro.screens.switch('worldselect');
        })
    },
    newworld: (world) => {
        world.name = $('#newworldname').val().trim();
        world.played = Date.now();
        world.data = {};
    },
    editworld: (world) => {
        world.name = $('#editworldname').val().trim();
    },
    serialize: (save) => {
        save.characters = [];
        for(let i in Micro.game.characters){
            let c = Micro.game.characters[i].serialize();
            if(c) save.characters.push(c);
        }
    },
    deserialize: (save) => {
        if(save.constructor === Object && Object.keys(save).length == 0) return {};
        for(let i in save.characters){
            if(Micro.common.classes[save.characters[i].kind]){
                Micro.common.classes[save.characters[i].kind].deserialize(save.characters[i]);
            }
        }
        if(Micro.game.player._carrying) Micro.game.player.carrying = Micro.game.characters.filter(e=>e.id==Micro.game.player._carrying)[0];
    },
    play: (world)=>{
        $('#game button').off('click');
        $('#resumegame').click(togglePause);
        $(window).blur(()=>{
            if(Micro.render.active) togglePause();
        })
        $('#pausesettings').click(()=>{
            $('#pausemenu').hide();
            Micro.screens.build('gamesettings');
            $('#gamesettings').show();
        })
        $('#backtopause').click(()=>{
            $('#gamesettings').hide();
            $('#pausemenu').show();
        });
        $('#quitgame').click(()=>{
            $('#pausemenu').hide();
            Micro.screens.switch('mainmenu');
            Micro.controls.relinquishKey('Escape', pauseSymbol);
            world.data = Micro.storage.serialize();
            Micro.storage.db.worlds.put(world);
        })
        world.played = Date.now();
        for(let i in Micro.game){
            delete Micro.game[i];
        }
        Micro.game.characters = Micro.game.characters ?? [];
        Micro.game.tiles = Micro.game.tiles ?? {};
        Micro.storage.deserialize(world.data);
        Micro.render.init();
        let pauseSymbol = Micro.controls.registerControl('Escape', togglePause);
        
        if(Micro.game.player) {
            console.log("*insert deltarune reference here*")
            return;
        }
        let player = new Player([0, 0]);
        Micro.game.player = player;
        let debug = new DebugLayer();
        Tile.fromMap(0, 0, [
            '▪▪▪▪▪▪▩▪▪▪▪▪▪',
            '▪▪▪▪▪▩□▩▪▪▪▪▪',
            '▪▪▪▪▩□□□▩▪▪▪▪',
            '▪▪▪▩□□□□□▩▪▪▪',
            '▪▪▩□□□□□□□▩▪▪',
            '▪▩□□□□□□□□□▩▪',
            '▩□□□□□□□□□□□▩',
            '▪▩□□□□□□□□□▩▪',
            '▪▪▩□□□□□□□▩▪▪',
            '▪▪▪▩□□□□□▩▪▪▪',
            '▪▪▪▪▩□□□▩▪▪▪▪',
            '▪▪▪▪▪▩□▩▪▪▪▪▪',
            '▪▪▪▪▪▪▩▪▪▪▪▪▪'
        ], -2);
        new setPieces.Opener([0, 0]);
    }
}
export {events};
