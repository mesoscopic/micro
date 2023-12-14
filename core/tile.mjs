/* This module will define Tiles, both foreground and background characters that make up Micro's world. */

class Tile extends Micro.render.Character {
    kind = "micro:Tile"
    constructor(char, pos, size, layer){
        super(char, pos, size, layer);
        (Micro.game.tiles?.[pos.join(',')]?.push?.(this))??(Micro.game.tiles[pos.join(',')] = [this]);
    }
    replace(char){
        Tile.fromChar(char, this.x, this.y, 0.9);
        this.remove();
    }
    remove(){
        super.remove();
        Micro.game.tiles[this.pos.join(',')].splice(Micro.game.tiles[this.pos.join(',')].indexOf(this), 1);
    }
    //Creates a set of Tiles from a string map of this format:
    // [
    //   "□■□",
    //   "■□■",
    //   "□■□"
    // ]
    static fromMap(x, y, strings){
        let list = [];
        let startX = x - Math.floor(Math.max(...strings.map((l)=>l.length))/2), startY = y - Math.floor(strings.length/2);
        for(let i in strings){
            for(let j in strings[i]){
                list.push(Tile.fromChar(strings[i][j], startX+parseInt(j), startY+parseInt(i), 0.9));
            }
        }
        return list;
    }
    static fromChar(char, x, y, size) {
        if(Tile.tileDictionary[char]){
            return new Tile.tileDictionary[char](char, [x, y], size);
        } else {
            return new Tile(char, [x, y], size, -2);
        }
    }
    static topAtPos(x, y){
        return Micro.game.tiles[[x, y].join(',')]?.sort((a, b) => b.layer - a.layer)?.[0];
    }
}

class VoidTile extends Tile {
    constructor(char, pos, size){
        super('▪', pos, 0.8, -2);
    }
    render(renderChar){
        let millisecondsPassed = (1000/render.fps);
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        let t = this, o = 1;
        Micro.game.characters.filter((v)=>v.layer>t.layer).forEach((c)=>{
            if(Math.abs(c.pos[0]-t.pos[0])<c.size&&Math.abs(c.pos[1]-t.pos[1])<c.size){
                let n = Math.sqrt(Math.abs(c.pos[0]-t.pos[0])**2 + Math.abs(c.pos[1]-t.pos[1])**2)/c.size;
                if(n<o) o = n;
            }
        });
        renderChar(this.char, [this.pos[0], this.pos[1]-0.25], this.size, o*(this.opacity??1), this.light);
    }
    serialize(){
        return;
    }
    static deserialize(s){
        return;
    }
}

class OpenWall extends Tile {
    kind = "micro:OpenWall"
    constructor(char, pos){
        super('□', pos, 0.8);
    }
}

class WallTile extends Tile {
    kind = "micro:WallTile"
    constructor(char, pos, size){
        super(char, pos, size, -1);
        this.blocksMovement = true;
        this.blocksLight = true;
    }
}

class UpgradableTile extends Tile {
    kind = "micro:UpgradableTile"
    constructor(char, pos, size){
        super(char, pos, size, -2);
    }
    activate(){
        if(!Micro.game.player.carrying) return;
        Micro.game.player.carrying.pos = this.pos;
        Micro.game.player.carrying.enable();
        Micro.game.player.carrying = null;
    }
}

Micro.common.Tile = Tile;
Micro.common.Tile.tileDictionary = {
    '□': UpgradableTile,
    '▩': WallTile,
    'o': OpenWall,
    '▪': VoidTile
};

Micro.common.classes["micro:Tile"] = Tile;
Micro.common.classes["micro:UpgradableTile"] = UpgradableTile;
Micro.common.classes["micro:WallTile"] = WallTile;
Micro.common.classes["micro:OpenWall"] = OpenWall;
Micro.common.classes["micro:VoidTile"] = VoidTile;
Micro.common.tiles = {UpgradableTile, WallTile, OpenWall, VoidTile};
export default Tile;