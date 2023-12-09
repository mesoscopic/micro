export class Upgrade extends Micro.render.Character {
    kind = "micro:Upgrade"
    constructor(char, pos, description, enabled){
        super(char, pos, 1, -1);
        if(enabled ?? true) this.enable();
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
        (Micro.game.tiles?.[this.pos.join(',')]?.push?.(this))??(Micro.game.tiles[this.pos.join(',')] = [this]);
    }
    //The upgrade's effects are undone
    disable(){
        this.exists = false;
        (Micro.game.tiles[this.pos.join(',')].splice(Micro.game.tiles[this.pos.join(',')].indexOf(this), 1));
    }
    serialize(){
        let self = super.serialize();
        self.description = this.description;
        return self;
    }
    static deserialize(s){
        let self = new this(s.char, s.pos, s.description, false); //We don't want to be applying effects twice, now do we?
        self.id = s.id;
        self.kind = s.kind;
        self.opacity = s.opacity;
        self.exists = s.exists;
        self.size = s.size;
        self.layer = s.layer;
    }
}
export class Opener extends Micro.common.Tile {
    kind = "micro:Opener"
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
    static deserialize(s){
        let self = new this(s.pos);
        self.id = s.id;
        self.kind = s.kind;
        self.opacity = s.opacity;
        self.exists = s.exists;
        self.char = s.char;
        self.size = s.size;
        self.layer = s.layer;
    }
}
export class OpenerUpgrade extends Upgrade {
    kind = "micro:OpenerUpgrade"
    constructor(char, pos, description){
        super(char, pos, description);
    }
    enable(){
        super.enable();
        let tile = Micro.common.Tile.topAtPos;
        tile(0, -6)?.replace?.('▩o'),tile(1, -5)?.replace?.('▩o'),tile(-1, -5)?.replace?.('▩o'),
        tile(0, 6)?.replace?.('▩o'),tile(1, 5)?.replace?.('▩o'),tile(-1, 5)?.replace?.('▩o'),
        tile(-6, 0)?.replace?.('▩o'),tile(-5, 1)?.replace?.('▩o'),tile(-5, -1)?.replace?.('▩o'),
        tile(6, 0)?.replace?.('▩o'),tile(5, 1)?.replace?.('▩o'),tile(5, -1)?.replace?.('▩o')
        this.light = 7;
    }
    disable(){
        super.disable();
        let tile = Micro.common.Tile.topAtPos;
        tile(0, -6)?.replace?.('▩'),tile(1, -5)?.replace?.('▩'),tile(-1, -5)?.replace?.('▩'),
        tile(0, 6)?.replace?.('▩'),tile(1, 5)?.replace?.('▩'),tile(-1, 5)?.replace?.('▩'),
        tile(-6, 0)?.replace?.('▩'),tile(-5, 1)?.replace?.('▩'),tile(-5, -1)?.replace?.('▩'),
        tile(6, 0)?.replace?.('▩'),tile(5, 1)?.replace?.('▩'),tile(5, -1)?.replace?.('▩')
        this.light = 0;
    }
}

Micro.common.classes["micro:Upgrade"] = Upgrade;
Micro.common.classes["micro:Opener"] = Opener;
Micro.common.classes["micro:OpenerUpgrade"] = OpenerUpgrade;