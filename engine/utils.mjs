export default {
    awaitCallback(thing, fun){
        return new Promise((res, rej)=>{
            try{
                fun.call(thing, ...(Array.from(arguments).slice(2)), res);
            } catch (e) {
                rej(e);
            }
        })
    },
    wait(ms){
        return new Promise((res)=>{
            setTimeout(res, ms);
        });
    }
}