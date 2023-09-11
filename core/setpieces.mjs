export class Upgrade extends Micro.render.Character {
    constructor(char, pos, description){
        super(char, pos, 1, -1);
        this.enable();
        this.description = description;
    }
    hover(){
        Micro.render.canvas.font = `bold 30px 'sharetechmono', 'unicodemono', monospace`;
        Micro.render.canvas.textAlign = "center";
        Micro.render.canvas.textBaseline = "top";
        Micro.render.canvas.fillStyle = '#000000';
        Micro.render.canvas.fillText(this.char+' :', Micro.render.width/2, 0);
        Micro.render.canvas.font = `normal 20px 'sharetechmono', 'unicodemono', monospace`;
        let ds = (this.description+'\n[Space] = '+this.char).split('\n')
        for(let i in ds){
            Micro.render.canvas.fillText(ds[i], Micro.render.width/2, 33+ 33*i);
        }
    }
    activate(){
        this.disable();
        Micro.game.player.carrying = this;
    }
    //The upgrade comes into effect
    enable(){
        this.exists = true;
        (Micro.game.Tile.positions?.[this.pos.join(',')]?.push?.(this))??(Micro.game.Tile.positions[this.pos.join(',')] = [this]);
    }
    //The upgrade's effects are undone
    disable(){
        this.exists = false;
        (Micro.game.Tile.positions[this.pos.join(',')].splice(Micro.game.Tile.positions[this.pos.join(',')].indexOf(this), 1));
    }
}
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
        Micro.render.canvas.fillText('[Space] = ▲', Micro.render.width/2, 33);
    }
    activate(){
        new OpenerUpgrade('▲', this.pos, '▩ -> ▪');
        this.remove();
    }
}
export class OpenerUpgrade extends Upgrade {
    constructor(char, pos, description){
        super(char, pos, description);
    }
    enable(){
        super.enable();
        let tile = Micro.game.Tile.topAtPos;
        tile(0, -6)?.replace?.('▩o'),tile(1, -5)?.replace?.('▩o'),tile(-1, -5)?.replace?.('▩o'),
        tile(0, 6)?.replace?.('▩o'),tile(1, 5)?.replace?.('▩o'),tile(-1, 5)?.replace?.('▩o'),
        tile(-6, 0)?.replace?.('▩o'),tile(-5, 1)?.replace?.('▩o'),tile(-5, -1)?.replace?.('▩o'),
        tile(6, 0)?.replace?.('▩o'),tile(5, 1)?.replace?.('▩o'),tile(5, -1)?.replace?.('▩o')
        this.light = 7;
    }
    disable(){
        super.disable();
        let tile = Micro.game.Tile.topAtPos;
        tile(0, -6)?.replace?.('▩'),tile(1, -5)?.replace?.('▩'),tile(-1, -5)?.replace?.('▩'),
        tile(0, 6)?.replace?.('▩'),tile(1, 5)?.replace?.('▩'),tile(-1, 5)?.replace?.('▩'),
        tile(-6, 0)?.replace?.('▩'),tile(-5, 1)?.replace?.('▩'),tile(-5, -1)?.replace?.('▩'),
        tile(6, 0)?.replace?.('▩'),tile(5, 1)?.replace?.('▩'),tile(5, -1)?.replace?.('▩')
        this.light = 0;
    }

}