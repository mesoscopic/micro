class Player extends Micro.render.Character {
    moveVector = [0, 0];
    constructor(char, pos, size){
        super(char, pos, size);
        this.enableControls();
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
        this.moveVector[0]+=vector[0];
        this.moveVector[1]+=vector[1];
    }
    subtractMovement(vector){
        this.moveVector[0]-=vector[0];
        this.moveVector[1]-=vector[1];
    }
    render(renderChar){
        let millisecondsPassed = isFinite(1000/Micro.render.fps)?1000/Micro.render.fps:0;
        for(let i in this.animations){
            this[i] += this.animations[i][1]*millisecondsPassed;
            if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
        }
        this.x += (this.moveVector[0]*millisecondsPassed/1000);
        this.y += (this.moveVector[1]*millisecondsPassed/1000);
        Micro.render.offset = this.pos;
        renderChar(this.char, this.pos, this.size, this.opacity??1);
    }
}

Micro.game.Player = Player;
export default Player;