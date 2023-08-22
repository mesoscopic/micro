/* This module will define Tiles, both foreground and background characters that make up Micro's world. */
import tileDictionary from './tiletypes.mjs'

class Tile extends Micro.render.Character {
    constructor(char, pos, size, layer){
        super(char, pos, size, layer);
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
    static tileDictionary = tileDictionary;
    static topAtPos(x, y){
        return Micro.render.characters.filter((e)=>e instanceof Tile && e.x == x && e.y == y).sort((a, b) => b.layer - a.layer)[0];
    }
}

Micro.game.Tile = Tile;
Micro.game.Tile.tileDictionary = tileDictionary;
export default Tile;