class Player extends Micro.render.Character {
    moveVector = [0, 0];
    constructor(pos, size){
        super('◇', pos, size);
        this.enableControls();
        this.maxSpeed = 1;
        this.accelerationTime = 500;
    }
    enableControls(){
        this.controls = [
            Micro.controls.registerControl('ArrowLeft', (p)=>{
                this.addMovement([-1, 0]);
                p.then(()=>{this.subtractMovement([-1, 0])});
            }, false),
            Micro.controls.registerControl('ArrowRight', (p)=>{
                this.addMovement([1, 0]);
                p.then(()=>{this.subtractMovement([1, 0])});
            }, false),
            Micro.controls.registerControl('ArrowUp', (p)=>{
                this.addMovement([0, -1]);
                p.then(()=>{this.subtractMovement([0, -1])});
            }, false),
            Micro.controls.registerControl('ArrowDown', (p)=>{
                this.addMovement([0, 1]);
                p.then(()=>{this.subtractMovement([0, 1])});
            }, false)
        ]
    }
    disableControls(){
        Micro.controls.relinquishKey('ArrowLeft', this.controls[0]);
        Micro.controls.relinquishKey('ArrowRight', this.controls[1]);
        Micro.controls.relinquishKey('ArrowUp', this.controls[2]);
        Micro.controls.relinquishKey('ArrowDown', this.controls[3]);
        delete this.controls;
    }
    addMovement(vector){
        let p = this, ax = vector[0]/(this.accelerationTime/50), ay = vector[1]/(this.accelerationTime/50), n = 0;
        let i = setInterval(()=>{
            n++;
            p.moveVector[0]+=ax;
            p.moveVector[1]+=ay;
            if(n == p.accelerationTime/50) clearInterval(i);
        }, 50);
    }
    subtractMovement(vector){
        let p = this, ax = vector[0]/(this.accelerationTime/50), ay = vector[1]/(this.accelerationTime/50), n = 0;
        let i = setInterval(()=>{
            n++;
            p.moveVector[0]-=ax;
            p.moveVector[1]-=ay;
            if(n == p.accelerationTime/50) clearInterval(i);
        }, 50);
    }
    render(renderChar){
        let millisecondsPassed = isFinite(1000/Micro.render.fps)?1000/Micro.render.fps:0;
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        this.x = parseFloat((this.x+(this.moveVector[0]*millisecondsPassed/1000)).toFixed(2));
        this.y = parseFloat((this.y+(this.moveVector[1]*millisecondsPassed/1000)).toFixed(2));
        Micro.render.offset = [-this.x, -this.y];
        let t = this, o = 1;
        render.characters.filter((v)=>v.layer>t.layer).forEach((c)=>{
            if(Math.abs(c.pos[0]-t.pos[0])<=1&&Math.abs(c.pos[0]-t.pos[0])<=1){
                o = 0.1;
            }
        });
        renderChar(this.char, this.pos, this.size, o*this.opacity??1);
        renderChar('◆', [this.x - (this.moveVector[0]/this.maxSpeed)/15, this.y - (this.moveVector[1]/this.maxSpeed)/15], this.size*0.5, o*this.opacity??1);
    }
}

Micro.game.Player = Player;
export default Player;