class Character {
    constructor(char, pos, size){
        this.char = char;
        this.pos = pos;
        this.size = size??1;
        render.characters.push(this);
    }
    render(renderChar){
        renderChar(this.char, this.pos, this.size, 1);
    }
    remove(){
        render.characters.splice(render.characters.indexOf(this), 1);
    }
}
const render = {
    active: false,
    scale: 50,
    offset: [0, 0],
    Character,
    characters: [],
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
            render.canvas.font = `${size*render.scale}px 'sharetechmono', 'unicodemono', monospace`;
            render.canvas.textAlign = "center";
            render.canvas.textBaseline = "middle";
            render.canvas.fillStyle = "#000000"+Math.floor((opacity*255).toString(16));
            render.canvas.fillText(char, render.width/2 + pos[0] + render.offset[0], render.height/2 + pos[1] + render.offset[1]);
        }
        for(let i in render.characters){
            render.characters[i].render(renderChar);
        }

        if(render.active) requestAnimationFrame(render.frame);
    }
}
export default render;