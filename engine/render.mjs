export default {
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
        if(this.lastFrame) this.fps = 1000/(time - this.lastFrame)
        this.lastFrame = time;
        $('#render').attr("height", window.innerHeight).attr("width", window.innerWidth);
        if(this.active) requestAnimationFrame(this.frame);
    }
}