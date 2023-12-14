class Bullet extends Micro.render.Character {
    kind = "micro:Bullet"
    constructor(char, pos, size, vector){
        super(char, pos, size, 1);
        this.moveVector = vector;
        this.lifetime = 0;
    }
    render(renderChar){
        if(!this.exists) return;
        let millisecondsPassed = isFinite(1000/Micro.render.fps)?1000/Micro.render.fps:0;
        this.lifetime += millisecondsPassed;
        if(this.lifetime > 10000) this.remove();
        this.x = parseFloat((this.x+(this.moveVector[0]*millisecondsPassed/1000)).toFixed(2));
        this.y = parseFloat((this.y+(this.moveVector[1]*millisecondsPassed/1000)).toFixed(2));
        Micro.game.characters.filter((e)=>e.blocksMovement).forEach((e)=>{
            if(Micro.utils.collide(e, this)) {
                this.remove();
            }
        });
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
        let magnitude = Math.sqrt(this.moveVector[0]**2 + this.moveVector[1]**2);
        let angle = (this.moveVector[0] < 0)?(2*Math.PI - Math.acos(-(this.moveVector[1] / magnitude))):Math.acos(-(this.moveVector[1] / magnitude));
        console.log(angle * 180/Math.PI);
        renderChar(this.char, this.pos, this.size, o*(this.opacity??1), 1, angle);
    }
    serialize(){
        return;
    }
    static deserialize(s){
        return;
    }
    vertices(){
        return [
            [this.x + this.size/2, this.y],
            [this.x - this.size/2, this.y],
            [this.x, this.y + this.size/2],
            [this.x, this.y - this.size/2]
        ]
    }
    doesPointIntersect(x, y){
        if(Math.sqrt(Math.abs(this.x - x)**2+Math.abs(this.y - y)**2) < this.size/2) return true
        else return false
    }
}

Micro.common.Bullet = Bullet;
Micro.common.classes["micro:Bullet"] = Bullet;
export default Bullet;