const render = {
    active: false,
    init: function(){
        this.active = true;
        this.canvas = $('#render').get(0).getContext('2d');
        requestAnimationFrame(this.frame);
    },
    stop: function(){
        this.active = false;
    },
    frame: function(time){
        if(render.lastFrame) render.fps = 1000/(time - render.lastFrame)
        render.lastFrame = time;
        $('#render').attr("height", window.innerHeight).attr("width", window.innerWidth);
        if(render.active) requestAnimationFrame(render.frame);
    }
}
export default render;