const events = {
    load: (self) => {
        console.log('Test Mod Loaded');
        Micro.modules.loaded[0].module.Player.prototype.render = (renderChar) => {
            let millisecondsPassed = isFinite(1000/Micro.render.fps)?1000/Micro.render.fps:0;
            for(let i in this.animations){
                this[i] += this.animations[i][1]*millisecondsPassed;
                if((this.animations[i][0]<0)?(this[i]<=this.animations[i][0]):(this[i]<=this.animations[i][0])) delete this.animations[i];
            }
            let newX = this.x + (this.moveVector[0]*millisecondsPassed/1000);
            let newY = this.y + (this.moveVector[1]*millisecondsPassed/1000);
            if(newX>10 || newX<-10 || newY>10 || newY<-10){
                return;
            }
            this.x = newX;
            this.y = newY;
            renderChar(this.char, this.pos, this.size, this.opacity??1);
        }
    }
}

export {events};