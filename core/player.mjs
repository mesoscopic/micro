/* This module defines the player and its movement.
 * It exposes the Player class to Micro.game.
 */

class Player extends Micro.render.Character {
    moveVector = [0, 0];
    constructor(pos, size){
        super('◇', pos, size);
        this.enableControls();
        this.maxSpeed = 3;
    }
    enableControls(){
        this.controls = [
            Micro.controls.registerControl('ArrowLeft', (p)=>{
                this.addMovement([-3, 0]);
                p.then(()=>{this.subtractMovement([-3, 0])});
            }, false),
            Micro.controls.registerControl('ArrowRight', (p)=>{
                this.addMovement([3, 0]);
                p.then(()=>{this.subtractMovement([3, 0])});
            }, false),
            Micro.controls.registerControl('ArrowUp', (p)=>{
                this.addMovement([0, -3]);
                p.then(()=>{this.subtractMovement([0, -3])});
            }, false),
            Micro.controls.registerControl('ArrowDown', (p)=>{
                this.addMovement([0, 3]);
                p.then(()=>{this.subtractMovement([0, 3])});
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
        this.moveVector[0] += vector[0];
        this.moveVector[1] += vector[1];
    }
    subtractMovement(vector){
        this.moveVector[0] -= vector[0];
        this.moveVector[1] -= vector[1];
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
        Micro.render.characters.filter((v)=>v.layer>t.layer).forEach((c)=>{
            if(Math.abs(c.pos[0]-t.pos[0])<=1&&Math.abs(c.pos[1]-t.pos[1])<=1){
                let distance = Math.sqrt(Math.abs(c.pos[0]-t.pos[0])**2 + Math.abs(c.pos[1]-t.pos[1])**2);
                o = 0.4*distance;
            }
        });
        renderChar(this.char, this.pos, this.size, o*(this.opacity??1));
        renderChar('◆', [this.x - (this.moveVector[0]/this.maxSpeed)/15, this.y - (this.moveVector[1]/this.maxSpeed)/15], this.size*0.5, o*this.opacity??1);
    }
}

Micro.game.Player = Player;
export default Player;