export default {
    awaitCallback(fun){
        return new Promise((res, rej)=>{
            try{
                fun(...(Array.from(arguments).slice(1)), res);
            } catch (e) {
                rej(e);
            }
        })
    }
}