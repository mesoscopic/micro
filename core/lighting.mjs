/* This code was originally written for C# by Adam Milazzo.
 * http://adammil.net/blog/v125_roguelike_vision_algorithms.html#mycode
 * I don't have a clue how this works
 */

let lightMap;

function blocksLight(x, y){
    return Micro.game.Tile.topAtPos(x, y).blocksLight ?? false;
}
function setVisible(x, y, origin, strength){
    lightMap[`${x},${y}`] = Math.min((lightMap[`${x},${y}`]??0) + Math.max(1-(Math.abs(origin[0] - x)+Math.abs(origin[1]-y))/strength, 0), 1)
}
function getDistance(x, y){
    return Math.sqrt(x**2 + y**2);
}
function compute(origin, rangeLimit){
    setVisible(origin[0], origin[1], origin, rangeLimit);
    for(let octant = 0; octant<8; octant++){
        computeOctant(octant, origin, rangeLimit, 1, new Slope(1, 1), new Slope(0, 1));
    }
    return lightMap;
}
function computeOctant(octant, origin, rangeLimit, x, top, bottom){
    for(; x <= rangeLimit; x++){
        let topY;
        {
            topY = ((x*2-1) * top.Y + top.X) / (top.X*2);
            if(BlocksLight(x, topY, octant, origin)){
                if(top.greaterOrEqual(topY*2+1, x*2) && !BlocksLight(x, topY+1, octant, origin) && !BlocksLight(x-1, topY+1, octant, origin)) topY++
            } else {
                if(BlocksLight(x-1, topY, octant, origin) && BlocksLight(x, topY-1, octant, origin)){
                    topY--;
                    top = new Slope(topY*2, x*2-1);
                } else {
                    let ax = x*2
                    if(BlocksLight(x+1, topY+1, octant, origin)) ax++;
                    if(top.greater(topY*2+1, ax)) topY++;
                }
            }
        }

        let bottomY;
        if(bottom.Y == 0) {bottomY = 0;}
        else {
            bottomY = ((x*2-1) * bottom.Y + bottom.X) / (bottom.X*2);
            if(bottom.greaterOrEqual(bottomY*2+1, x*2) && BlocksLight(x, bottomY, octant, origin) && !BlocksLight(x, bottomY+1, octant, origin)){
                bottomY++;
            }
        }

        let wasOpaque = -1;
        for(let y = topY; y >= bottomY; y=Math.abs(y-1)){
            if(x+y/2 <= rangeLimit){
                let isOpaque = BlocksLight(x, y, octant, origin);
                let isVisible = isOpaque;
                if(!isVisible){
                    isVisible = (y!=topY || top.greaterOrEqual(y, x)) && (y!=bottomY || bottom.lessOrEqual(y, x));
                }
                if(isVisible) SetVisible(x, y, octant, origin, rangeLimit);
                if(x!=rangeLimit){
                    if(isOpaque){
                        if(wasOpaque == 0){
                            let nx = x*2, ny = y*2+1;
                            if(top.greater(ny, nx)){
                                if(y===bottomY) {bottom = new Slope(ny, nx); break;}
                                else computeOctant(octant, origin, rangeLimit, x+1, top, new Slope(ny, nx));
                            } else {
                                if(y==bottomY) return;
                            }
                        }
                        wasOpaque = 1;
                    } else {
                        if(wasOpaque > 0){
                            let nx = x*2, ny = y*2+1;
                            if(BlocksLight(x+1, y, octant, origin)) {nx = x*4 + 1; ny = y*4+1;}
                            if(bottom.greaterOrEqual(ny, nx)) return;
                            top = new Slope(ny, nx);
                        }
                        wasOpaque = 0;
                    }
                }
            }
        }
        if(wasOpaque != 0) break;
    }
}
function BlocksLight(x, y, octant, origin){
    let nx = origin[0], ny = origin[1];
    switch(octant){
        case 0: nx += x; ny -= y; break;
        case 1: nx += y; ny -= x; break;
        case 2: nx -= y; ny -= x; break;
        case 3: nx -= x; ny -= y; break;
        case 4: nx -= x; ny += y; break;
        case 5: nx -= y; ny += x; break;
        case 6: nx += y; ny += x; break;
        case 7: nx += x; ny += y; break;
    }
    return blocksLight(nx, ny);
}
function SetVisible(x, y, octant, origin, strength){
    let nx = origin[0], ny = origin[1];
    switch(octant){
        case 0: nx += x; ny -= y; break;
        case 1: nx += y; ny -= x; break;
        case 2: nx -= y; ny -= x; break;
        case 3: nx -= x; ny -= y; break;
        case 4: nx -= x; ny += y; break;
        case 5: nx -= y; ny += x; break;
        case 6: nx += y; ny += x; break;
        case 7: nx += x; ny += y; break;
    }
    return setVisible(nx, ny, origin, strength);
}
class Slope {
    constructor(y, x){
        this.Y = y;
        this.X = x;
    }
    greater(y, x){
        return this.Y*x > this.X*y;
    }
    greaterOrEqual(y, x){
        return this.Y*x >= this.X*y;
    }
    less(y, x){
        return this.Y*x < this.X*y;
    }
    lessOrEqual(y, x){
        return this.Y*x <= this.X*y;
    }
}

Micro.game.lightWorld = function(){
    lightMap = {};
    Micro.render.characters.filter((e)=>e.light>0).forEach((e)=>{
        compute([Math.round(e.x), Math.round(e.y)], e.light);
    });
    return lightMap;
}

export default Micro.game.lightWorld