export default {
    //Turns a normal callback into a Promise. syntax is awaitCallback(thisObject, functionToBeCalled, ...arguments), assuming callback is the last argument.
    awaitCallback(thing, fun){
        return new Promise((res, rej)=>{
            try{
                fun.call(thing, ...(Array.from(arguments).slice(2)), res);
            } catch (e) {
                rej(e);
            }
        })
    },
    //Returns a promise that resolves in a number of milliseconds.
    wait(ms){
        return new Promise((res)=>{
            setTimeout(res, ms);
        });
    },
    //Tests for intersection between two Micro.render.Characters
    collide(c1, c2){
        let intersecting = false;
        c1.vertices.forEach((v)=>{
            intersecting = intersecting || c2.doesPointIntersect(...v);
        })
        c2.vertices.forEach((v)=>{
            intersecting = intersecting || c1.doesPointIntersect(...v);
        })
    }
}