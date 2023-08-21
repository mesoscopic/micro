/* This module will define Tiles, both foreground and background characters that make up Micro's world. */

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
    static fromMap(x, y, strings, layer){
        let list = [];
        let startX = x - Math.floor(Math.max(...strings.map((l)=>l.length))/2), startY = y - Math.floor(strings.length/2);
        for(let i in strings){
            for(let j in strings[i]){
                list.push(new Tile(strings[i][j], [startX+j, startY+i], 1, layer));
            }
        }
        return list;
    }
}
export default Tile;