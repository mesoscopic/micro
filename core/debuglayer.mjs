/* This module defines the DebugLayer Character, which does not render a character and instead draws the debug overlay. */


export default class DebugLayer extends Micro.render.Character {
    kind = "micro:DebugLayer"
    constructor(){
        super('', [0, 0], 1, -99);
    }
    render(){
        if(!Micro.settings.data.debug.value) return;
        Micro.render.canvas.font = `20px 'sharetechmono', 'unicodemono', monospace`;
        Micro.render.canvas.textAlign = "left";
        Micro.render.canvas.textBaseline = "bottom";
        Micro.render.canvas.fillStyle = '#000000';
        Micro.render.canvas.fillText(Math.floor(Micro.render.fps) + ' FPS', 0, Micro.render.height);
        Micro.render.canvas.fillText('Pos: ('+Micro.game.player.x.toFixed(2)+', '+Micro.game.player.y.toFixed(2)+')', 0, Micro.render.height - 22);
        Micro.render.canvas.fillText('Characters: '+Micro.game.characters.length, 0, Micro.render.height - 44);
    }
}

Micro.common.DebugLayer = DebugLayer;
Micro.common.classes["micro:DebugLayer"] = DebugLayer;