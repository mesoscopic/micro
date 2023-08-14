class Character {
    animations = {}
    constructor(char, pos, size){
        this.char = char;
        this.pos = pos;
        this.size = size??1;
        render.characters.push(this);
    }
    animate(prop, target, time){
        //*angry floating point math noises*
        target = target.toFixed(3);
        if(this.animations[prop]) this.animations[prop] = [this.animations[prop][0]+target, (target-this[prop])/time];
        this.animations[prop] = [target, (target-this[prop])/time];
    }
    render(renderChar){
        let millisecondsPassed = (1000/render.fps);
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        renderChar(this.char, this.pos, this.size, this.opacity??1);
    }
    remove(){
        render.characters.splice(render.characters.indexOf(this), 1);
    }
    get x(){
        return this.pos[0];
    }
    set x(val){
        this.pos[0] = val;
    }
    get y(){
        return this.pos[1];
    }
    set y(val){
        this.pos[1] = val;
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
        else render.fps = 0;
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
            render.canvas.fillText(char, render.width/2 + (pos[0] + render.offset[0])*render.scale, render.height/2 + (pos[1] + render.offset[1])*render.scale);
        }
        for(let i in render.characters){
            render.characters[i].render(renderChar);
        }
        render.canvas.font = `20px 'sharetechmono', 'unicodemono', monospace`;
        render.canvas.textAlign = "left";
        render.canvas.textBaseline = "bottom";
        render.canvas.fillStyle = '#000000';
        render.canvas.fillText(Math.floor(render.fps) + ' FPS', 0, render.height);

        if(render.active) requestAnimationFrame(render.frame);
    }
}
export default render;