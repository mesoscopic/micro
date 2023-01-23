import util from './commonfunctions.mjs'

export default class EnemyCamp {
  constructor(w, e){
    if(e) return;
    this.spawn(w??window.world)
  }
  spawn(w){
    let x = Math.floor(Math.random()*48) + 80
    let y = Math.floor(Math.random()*22)
    let tile = w.gameworld[y][x]
    if(tile != '□') return this.spawn(w)
    this.pos = [x, y]
    w.camps.push(this)
    return this
  }
  dieInAbout(min, max){
    let interval = Math.floor(Math.random()*Math.abs(max-min) + min)
    this.decay = setTimeout(this.die.bind(this), interval*1000)
  }
  cancelDecay(){
    clearInterval(this.decay)
    return this
  }
  die(){
    window.world.camps.splice(window.world.camps.indexOf(this), 1)
  }
  raid(){
    window.world.cutscene = true
    $("#current-cutscene").html('<use href="#camp_entrance">')
    $("#cutscene-overlay").show()
    window.world.cutsceneControls = () => {}
    $('#ce_player').attr('x', '50');
    util.animateAttr($('#ce_player'), 'x', 150, 2000, ()=>{
      $('#current-cutscene').html('<use href="#camp_lol">');
      window.world.cutsceneControls = (c) => {
        if(c == 4){
          window.world.cutscene = false
          $('#cutscene-overlay').hide()
        }
      }
    })
    this.die()
  }
  static from(a, w){
    if(!a) a = []
    return a.map((e)=>$.extend(new EnemyCamp(w, true), e))
  }
}