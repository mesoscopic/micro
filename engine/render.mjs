class Character {
    animations = {}
    kind = "core:Character"
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
        Micro.game.characters.push(this);
        Micro.game.characters.sort((a, b)=>a.layer-b.layer);
        this.exists = true;
        this.id = crypto.randomUUID();
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
        if(!this.exists) return;
        let millisecondsPassed = (1000/render.fps);
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        let t = this, o = 1;
        Micro.game.characters.filter((v)=>v.layer>t.layer&&v.exists).forEach((c)=>{
            if(Math.abs(c.pos[0]-t.pos[0])<c.size&&Math.abs(c.pos[1]-t.pos[1])<c.size){
                let n = Math.sqrt(Math.abs(c.pos[0]-t.pos[0])**2 + Math.abs(c.pos[1]-t.pos[1])**2)/c.size;
                if(n<o) o = n;
            }
        });
        renderChar(this.char, this.pos, this.size, o*(this.opacity??1), this.light);
    }
    //Performs collision detection for this character, assuming a rectangular hitbox. This can be customized mathematically if necessary.
    doesPointIntersect(x, y){
        let edge = this.size/2;
        if(Math.abs(this.x - x)<edge && Math.abs(this.y - y)<edge) return true
        else return false
    }
    //Returns a list of vertices for collision detection.
    vertices(){
        return [
            [this.x + this.size/2, this.y + this.size/2],
            [this.x - this.size/2, this.y + this.size/2],
            [this.x + this.size/2, this.y - this.size/2],
            [this.x - this.size/2, this.y - this.size/2]
        ]
    }
    //Deletes the character.
    remove(){
        Micro.game.characters.splice(Micro.game.characters.indexOf(this), 1);
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

    serialize(){
        let self = {};
        self.kind = this.kind;
        self.pos = this.pos;
        self.size = this.size;
        self.opacity = this.opacity;
        self.char = this.char;
        self.exists = this.exists;
        self.id = this.id;
        self.layer = this.layer;
        return self;
    }
    static deserialize(s){
        let self = new this(s.char, s.pos, s.size, s.layer);
        self.id = s.id;
        self.kind = s.kind;
        self.opacity = s.opacity;
        self.exists = s.exists;
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
        let lightMap = Micro.common?.lightWorld?.();
        render.canvas.clearRect(0, 0, render.width, render.height);
        function renderChar(char, pos, size, opacity, fullbright){
            if(!render.isOnscreen(pos, size)) return;
            let lightX = Math.round(pos[0]), lightY = Math.round(pos[1]), light = lightMap?(lightMap[`${lightX},${lightY}`] ?? 0):1;
            if(opacity*(fullbright?1:light) == 0) return;
            render.canvas.font = `${2*size*render.scale}px 'unicodemono', monospace`;
            render.canvas.textAlign = "center";
            render.canvas.textBaseline = "middle";
            render.canvas.fillStyle = "rgba(0, 0, 0, "+opacity*(fullbright?1:light)+')';
            render.canvas.fillText(char, render.width/2 + (pos[0] + render.offset[0])*render.scale, render.height/2 + (pos[1] + render.offset[1] - 0.075*size)*render.scale);
        }
        for(let i in Micro.game.characters){
            Micro.game.characters[i].render(renderChar);
        }
        if(render.active) requestAnimationFrame(render.frame);
    },
    isOnscreen(pos, size){
        let leftBoundary = -(render.width/2)/render.scale - render.offset[0], rightBoundary = render.width/2/render.scale - render.offset[0];
        let topBoundary = -(render.height/2)/render.scale - render.offset[1], bottomBoundary = render.height/2/render.scale - render.offset[1];
        return ((pos[0] + size/2) >= leftBoundary && (pos[0] - size/2) <= rightBoundary && (pos[1] + size/2) >= topBoundary && (pos[1] - size/2) <= bottomBoundary)
    }
}
export default render;