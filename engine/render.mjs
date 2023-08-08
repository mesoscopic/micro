const render = {
    active: false,
    scale: 1,
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
        function renderChar(char, pos, size, opacity){
            render.canvas.font = `${size*scale}px 'sharetechmono', 'unicodemono', monospace`;
            render.canvas.textAlign = "center";
            render.canvas.textBaseline = "middle";
            render.canvas.fillStyle = "#000000"+(opacity*255).toString(16);
            render.canvas.fillText(char, render.width/2 + pos[0], render.height/2 + pos[1]);
        }
        renderChar('◈', [20, 20], 1, 0.9);

        if(render.active) requestAnimationFrame(render.frame);
    }
}
export default render;