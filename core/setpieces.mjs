export class Opener extends Micro.game.Tile {
    constructor(pos){
        super('△', pos, 1, -1);
    }
    hover(){
        Micro.render.canvas.font = `bold 30px 'sharetechmono', 'unicodemono', monospace`;
        Micro.render.canvas.textAlign = "center";
        Micro.render.canvas.textBaseline = "top";
        Micro.render.canvas.fillStyle = '#000000';
        Micro.render.canvas.fillText(this.char+' :', Micro.render.width/2, 0);
        Micro.render.canvas.font = `normal 20px 'sharetechmono', 'unicodemono', monospace`;
        Micro.render.canvas.fillText(this.char=='△'?'[Space] = ▲':'▩ -> □', Micro.render.width/2, 33);
    }
    activate(){
        this.char = '▲';
        let tile = Micro.game.Tile.topAtPos;
        tile(0, -6).replace('□'),tile(1, -6).replace('□'),tile(-1, -6).replace('□'),tile(1, -5).replace('□'),tile(-1, -5).replace('□'),
        tile(0, 6).replace('□'),tile(1, 6).replace('□'),tile(-1, 6).replace('□'),tile(1, 5).replace('□'),tile(-1, 5).replace('□'),
        tile(-6, 0).replace('□'),tile(-6, 1).replace('□'),tile(-6, -1).replace('□'),tile(-5, 1).replace('□'),tile(-5, -1).replace('□'),
        tile(6, 0).replace('□'),tile(6, 1).replace('□'),tile(6, -1).replace('□'),tile(5, 1).replace('□'),tile(5, -1).replace('□')
        this.activate = null;
    }
}