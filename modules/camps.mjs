export default class EnemyCamp {
  constructor(array){
    //array refers to the array of camps: in this case found at world.camps
    this.group = array
    this.spawn()
  }
  spawn(){
    let x = Math.floor(Math.random()*48) + 80
    let y = Math.floor(Math.random()*22)
    let tile = window.world.gameworld[y][x]
    if(tile != '□') return this.spawn()
    this.pos = [x, y]
  }
  die(){
    this.group.splice(this.group.indexOf(this), 1)
  }
  raid(){
    alert("cool i guess")
    this.die()
  }
}