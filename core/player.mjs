/* This module defines the player and its movement.
 * It exposes the Player class to Micro.game.
 */

class Player extends Micro.render.Character {
    moveVector = [0, 0];
    constructor(pos, size){
        super('◇', pos, size, 2);
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
        this.x = parseFloat((this.x+(this.moveVector[0]*millisecondsPassed/1000)).toFixed(2));
        this.y = parseFloat((this.y+(this.moveVector[1]*millisecondsPassed/1000)).toFixed(2));
        Micro.render.offset = [-this.x, -this.y];
        super.render(renderChar);
        renderChar('◆', [this.x - (this.moveVector[0]/this.maxSpeed)/15*this.size, this.y - (this.moveVector[1]/this.maxSpeed)/15*this.size], this.size*0.5, this.opacity??1);
    }
    //Creates a taxicab circle hitbox.
    doesPointIntersect(x, y){
        if(Math.abs(this.x - x)+Math.abs(this.y - y) < this.size/2) return true
        else return false
    }
}

Micro.game.Player = Player;
export default Player;