export default class DebugLayer extends Micro.render.Character {
    constructor(){
        super('', [0, 0], 1);
    }
    render(){
        Micro.render.canvas.font = `20px 'sharetechmono', 'unicodemono', monospace`;
        Micro.render.canvas.textAlign = "left";
        Micro.render.canvas.textBaseline = "bottom";
        Micro.render.canvas.fillStyle = '#000000';
        Micro.render.canvas.fillText(Math.floor(render.fps) + ' FPS', 0, render.height);
        Micro.render.canvas.fillText('Pos: ('+Micro.game.player.x+', '+Micro.game.player.y+')', 0, render.height - 22);
    }
}