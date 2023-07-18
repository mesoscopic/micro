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
        render.width = window.innerWidth;
        render.height = window.innerHeight;
        $('#render').attr("height", render.width).attr("width", render.width);

        render.canvas.clearRect(0, 0, render.width, render.height);
        render.canvas.fillText("i promise stuff is happening here", render.width/2-render.canvas.measureText("i promise stuff is happening here")/2, render.height/2);

        if(render.active) requestAnimationFrame(render.frame);
    }
}
export default render;