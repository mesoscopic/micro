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
        this.moveVector[0]+=vector[0];
        this.moveVector[1]+=vector[1];
    }
    render(renderChar){
        let millisecondsPassed = (1000/Micro.render.fps);
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        this.x += (moveVector[0]*1000/millisecondsPassed);
        this.y += (moveVector[1]*1000/millisecondsPassed);
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
        let controls = [
            Micro.controls.registerControl('ArrowLeft', (p)=>{
                player.addMovement([-3, 0]);
                p.then(()=>{player.subtractMovement([-3, 0])});
            }),
            Micro.controls.registerControl('ArrowRight', (p)=>{
                player.addMovement([3, 0]);
                p.then(()=>{player.subtractMovement([3, 0])});
            }),
            Micro.controls.registerControl('ArrowUp', (p)=>{
                player.addMovement([0, -3]);
                p.then(()=>{player.subtractMovement([0, -3])});
            }),
            Micro.controls.registerControl('ArrowDown', (p)=>{
                player.addMovement([0, 3]);
                p.then(()=>{player.subtractMovement([0, 3])});
            })
        ]
    }
}
export {events}