class Character {
    animations = {}
    constructor(char, pos, size, layer){
        this.char = char; //The Unicode character a Character renders as
        this.pos = pos; //A 2D vector for position
        this.size = size??1; //Size, default 1
        this.layer = layer??0; //Layer. Objects in higher layers will make this Character more transparent as they move on top of it.
        //Layers used by vanilla:
        //-2: Background tiles
        //-1: Foreground tiles
        //0: Moving entities
        //1: Particles
        //2: The Player
        render.characters.push(this);
        render.characters.sort((a, b)=>a.layer-b.layer);
    }
    //Changes a numerical property over an ms time.
    animate(prop, target, time){
        //*angry floating point math noises*
        target = target.toFixed(3);
        if(this.animations[prop]) this.animations[prop] = [this.animations[prop][0]+target, (target-this[prop])/time];
        this.animations[prop] = [target, (target-this[prop])/time];
    }
    //Does processing every frame. renderChar draws the character with respect for game offset and scale.
    render(renderChar){
        let millisecondsPassed = (1000/render.fps);
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        let t = this, o = 1;
        Micro.render.characters.filter((v)=>v.layer>t.layer).forEach((c)=>{
            if(Math.abs(c.pos[0]-t.pos[0])<c.size&&Math.abs(c.pos[1]-t.pos[1])<c.size){
                let n = Math.sqrt(Math.abs(c.pos[0]-t.pos[0])**2 + Math.abs(c.pos[1]-t.pos[1])**2)/c.size;
                if(n<o) o = n;
            }
        });
        renderChar(this.char, this.pos, this.size, o*(this.opacity??1));
    }
    //Performs collision detection for this character, assuming a rectangular hitbox. This can be customized mathematically if necessary.
    doesPointIntersect(x, y){
        let edge = this.size/2;
        if(Math.abs(this.x - x)<edge || Math.abs(this.y - y)<edge) return true
        else return false
    }
    //Deletes the character.
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
    scale: 30,
    offset: [0, 0],
    Character,
    //A list of active characters, in order of layer.
    characters: [],
    //Starts the render cycle.
    init: function(){
        this.active = true;
        this.canvas = $('#render').get(0).getContext('2d');
        requestAnimationFrame(this.frame);
    },
    //Stops the render cycle.
    stop: function(){
        this.active = false;
    },
    //Runs every frame.
    frame: function(time){
        if(render.lastFrame) render.fps = 1000/(time - render.lastFrame)
        else render.fps = 0;
        render.lastFrame = time;
        render.width = window.innerWidth;
        render.height = window.innerHeight;
        $('#render').attr("height", render.width).attr("width", render.width);

        render.canvas.clearRect(0, 0, render.width, render.height);
        function renderChar(char, pos, size, opacity){
            render.canvas.font = `${2*size*render.scale}px 'unicodemono', monospace`;
            render.canvas.textAlign = "center";
            render.canvas.textBaseline = "middle";
            render.canvas.fillStyle = "rgba(0, 0, 0, "+opacity+')';
            render.canvas.fillText(char, render.width/2 + (pos[0] + render.offset[0])*render.scale, render.height/2 + (pos[1] + render.offset[1] - 0.05*size)*render.scale);
        }
        for(let i in render.characters){
            render.characters[i].render(renderChar);
        }
        
        if(render.active) requestAnimationFrame(render.frame);
    }
}
export default render;