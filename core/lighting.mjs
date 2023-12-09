let lightMap;

function compute(x, y, light){
    Micro.game.characters.filter((e)=>e instanceof Micro.common.Tile && e.exists && (Math.abs(x-e.x)+Math.abs(y-e.y))<=light).forEach((e)=>{
        let distance = Math.abs(x-e.x)+Math.abs(y-e.y)
        lightMap[`${e.x},${e.y}`] = Math.min(1, (lightMap[`${e.x},${e.y}`]??0)+(light-distance)/light);
    })
}

Micro.common.lightWorld = function(){
    lightMap = {};
    Micro.game.characters.filter((e)=>e.light>0).forEach((e)=>{
        compute(e.x, e.y, e.light);
    });
    return lightMap;
}

export default Micro.common.lightWorld