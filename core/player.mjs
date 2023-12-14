/* This module defines the player and its movement.
 * It exposes the Player class to Micro.common.
 */

import Bullet from './bullet.mjs'

class Player extends Micro.render.Character {
    kind = "micro:Player"
    moveVector = [0, 0];
    constructor(pos, size){
        super('◇', pos, size, 2);
        this.maxSpeed = 3;
        this.enableControls();
        this.light = 5;
        this.prevPositions = [];
        this.dashVector = [0, 0];
    }
    enableControls(){
        this.controls = [
            Micro.controls.registerControl('KeyA', (p)=>{
                if(this.timeSinceLeft < 300){
                    this.dashVector[0] = -15;
                    if(!this.dashCooldown || this.dashCooldown < 0){
                        this.dashing = 200;
                        this.dashCooldown = 1000;
                        this.prevPositions = [[this.x, this.y]];
                    }
                }
                this.timeSinceLeft = 0;
                this.addMovement([-3, 0]);
                p.then(()=>{this.subtractMovement([-3, 0])});
            }, false),
            Micro.controls.registerControl('KeyD', (p)=>{
                if(this.timeSinceRight < 300){
                    this.dashVector[0] = 15;
                    if(!this.dashCooldown || this.dashCooldown < 0){
                        this.dashing = 200;
                        this.dashCooldown = 1000;
                        this.prevPositions = [[this.x, this.y]];
                    }
                }
                this.timeSinceRight = 0;
                this.addMovement([3, 0]);
                p.then(()=>{this.subtractMovement([3, 0])});
            }, false),
            Micro.controls.registerControl('KeyW', (p)=>{
                if(this.timeSinceUp < 300){
                    this.dashVector[1] = -15;
                    if(!this.dashCooldown || this.dashCooldown < 0){
                        this.dashing = 200;
                        this.dashCooldown = 1000;
                        this.prevPositions = [[this.x, this.y]];
                    }
                }
                this.timeSinceUp = 0;
                this.addMovement([0, -3]);
                p.then(()=>{this.subtractMovement([0, -3])});
            }, false),
            Micro.controls.registerControl('KeyS', (p)=>{
                if(this.timeSinceDown < 300){
                    this.dashVector[1] = 15;
                    if(!this.dashCooldown || this.dashCooldown < 0){
                        this.dashing = 200;
                        this.dashCooldown = 1000;
                        this.prevPositions = [[this.x, this.y]];
                    }
                }
                this.timeSinceDown = 0;
                this.addMovement([0, 3]);
                p.then(()=>{this.subtractMovement([0, 3])});
            }, false),
            Micro.controls.registerControl('Space', ()=>{
                Micro.common.Tile.topAtPos(Math.round(this.x), Math.round(this.y))?.activate?.();
            }),
            Micro.controls.registerControl('LMB', ()=>{
                if(this.bulletCooldown) return;
                let screenX = Micro.render.width/2 + (this.pos[0] + Micro.render.offset[0])*Micro.render.scale;
                let screenY = Micro.render.height/2 + (this.pos[1] + Micro.render.offset[1] - 0.075*this.size)*Micro.render.scale;
                let vector = [(Micro.controls.mouseX - screenX), (Micro.controls.mouseY - screenY)], magnitude = Math.sqrt(vector[0]**2 + vector[1]**2);
                vector = [vector[0]/magnitude*5, vector[1]/magnitude*5];
                new Bullet('⧫', [this.x, this.y], 0.6, vector);
                this.bulletCooldown = 400;
            })
        ]
    }
    disableControls(){
        Micro.controls.relinquishKey('KeyA', this.controls[0]);
        Micro.controls.relinquishKey('KeyD', this.controls[1]);
        Micro.controls.relinquishKey('KeyW', this.controls[2]);
        Micro.controls.relinquishKey('KeyS', this.controls[3]);
        Micro.controls.relinquishKey('Space', this.controls[4]);
        Micro.controls.relinquishKey('LMB', this.controls[5]);
        this.dashing = 0;
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
        Micro.common.world.generateTerrain();
        let millisecondsPassed = isFinite(1000/Micro.render.fps)?1000/Micro.render.fps:0;
        let oldPos = [this.x, this.y];
        if(!this.dashing || this.dashing < 0){
            this.x = parseFloat((this.x+(this.moveVector[0]*millisecondsPassed/1000)).toFixed(2));
            this.y = parseFloat((this.y+(this.moveVector[1]*millisecondsPassed/1000)).toFixed(2));
        } else {
            this.dashing = Math.max(0, this.dashing - millisecondsPassed);
            this.x = parseFloat((this.x+(this.dashVector[0]*millisecondsPassed/1000)).toFixed(2));
            this.y = parseFloat((this.y+(this.dashVector[1]*millisecondsPassed/1000)).toFixed(2));
            if(!this.dashing) this.dashVector = [0, 0];
        }
        this.dashCooldown = Math.max(0, this.dashCooldown - millisecondsPassed);
        this.bulletCooldown = Math.max(0, this.bulletCooldown - millisecondsPassed);
        this.timeSinceLeft = Math.min(500, this.timeSinceLeft + millisecondsPassed);
        this.timeSinceRight = Math.min(500, this.timeSinceRight + millisecondsPassed);
        this.timeSinceUp = Math.min(500, this.timeSinceUp + millisecondsPassed);
        this.timeSinceDown = Math.min(500, this.timeSinceDown + millisecondsPassed);
        let blocked = false;
        Micro.game.characters.filter((e)=>e.blocksMovement).forEach((e)=>{
            if(Micro.utils.collide(e, Micro.game.player)) blocked = true;
        });
        if(blocked) this.pos = oldPos
        Micro.render.offset = [-this.x, -this.y];
        if(this.dashing && this.dashing > 0){
            this.prevPositions.push([this.x, this.y]);
            for(let i in this.prevPositions){
                renderChar(this.char, this.prevPositions[i], this.size, Math.max(0, 1-(this.prevPositions.length - i)*0.15), 0);
            }
        }
        super.render(renderChar);
        renderChar('◆', [this.x - (this.moveVector[0]/this.maxSpeed)/15*this.size, this.y - (this.moveVector[1]/this.maxSpeed)/15*this.size], this.size*0.5, this.opacity??1, this.light);
        if(this.carrying) {
            this.carrying.pos = this.pos;
            renderChar(this.carrying.char, [this.x + this.size*Math.cos(Date.now()/1000), this.y + this.size*Math.sin(Date.now()/1000)], this.size * 0.5, 1, this.light);
            this.carrying.hover?.();
        } else {
            Micro.common.Tile.topAtPos(Math.round(this.x), Math.round(this.y))?.hover?.();
        }
    }
    //Creates a taxicab circle hitbox.
    doesPointIntersect(x, y){
        if(Math.abs(this.x - x)+Math.abs(this.y - y) < this.size/2) return true
        else return false
    }
    //Returns a list of vertices for the polygonal collision detection.
    vertices(){
        return [
            [this.x + this.size/2, this.y],
            [this.x - this.size/2, this.y],
            [this.x, this.y + this.size/2],
            [this.x, this.y - this.size/2]
        ]
    }
    serialize(){
        let self = super.serialize();
        self.maxSpeed = this.maxSpeed;
        self.carrying = this?.carrying?.id;
        return self;
    }
    static deserialize(s){
        let self = new this(s.pos, s.size);
        self.id = s.id;
        self.kind = s.kind;
        self.char = s.char;
        self.opacity = s.opacity;
        self.exists = s.exists;
        self.layer = s.layer;
        self._carrying = s.carrying;
        console.log("*insert undertale reference here*")
        Micro.game.player = self;
    }
}

Micro.common.Player = Player;
Micro.common.classes["micro:Player"] = Player;
export default Player;