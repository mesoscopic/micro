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

class Player extends Micro.render.Character {
    moveVector = [0, 0];
    constructor(char, pos, size){
        super(char, pos, size);
    }
    addMovement(vector){
        this.moveVector[0]+=vector[0];
        this.moveVector[1]+=vector[1];
    }
    subtractMovement(vector){
        this.moveVector[0]-=vector[0];
        this.moveVector[1]-=vector[1];
    }
    render(renderChar){
        let millisecondsPassed = isFinite(1000/Micro.render.fps)?1000/Micro.render.fps:0;
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        this.x += (this.moveVector[0]*millisecondsPassed/1000);
        this.y += (this.moveVector[1]*millisecondsPassed/1000);
        renderChar(this.char, this.pos, this.size, this.opacity??1);
    }
}

const events = {
    load: (self)=>{
        console.log('Vanilla Micro got loaded');
        new Micro.settings.SettingsCategory('visuals', 'Visual Settings');
        new Micro.settings.EnumSetting('theme', 'Theme', {
            default: 'Auto',
            category: 'visuals',
            options: ['Light', 'Dark', 'Auto']
        });
        new Micro.settings.SettingsCategory('debug', 'Debug Settings');
        new Micro.settings.ToggleSetting('globals', 'Expose global variables', {
            default: false,
            category: 'debug'
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
        if(Micro.settings.data.globals) window.player = player;
        let controls = [
            Micro.controls.registerControl('ArrowLeft', (p)=>{
                player.addMovement([-1, 0]);
                p.then(()=>{player.subtractMovement([-1, 0])});
            }, false),
            Micro.controls.registerControl('ArrowRight', (p)=>{
                player.addMovement([1, 0]);
                p.then(()=>{player.subtractMovement([1, 0])});
            }, false),
            Micro.controls.registerControl('ArrowUp', (p)=>{
                player.addMovement([0, -1]);
                p.then(()=>{player.subtractMovement([0, -1])});
            }, false),
            Micro.controls.registerControl('ArrowDown', (p)=>{
                player.addMovement([0, 1]);
                p.then(()=>{player.subtractMovement([0, 1])});
            }, false)
        ]
    }
}
export {events, Player, updateTheme};