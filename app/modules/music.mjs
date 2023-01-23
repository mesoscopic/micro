import Howler from './howler.mjs'

window.music = {
  soundtracks: {},
  playingSoundtrack: null,
  init: function(){
    if(world.gameworld.length == 1) this.soundtracks.start.start().next('safe');
    else if(world.player.pos[0]<42 && world.player.pos[1]<4) this.soundtracks.safe.start();
    else this.soundtracks.world.start();
  },
  stop: function(){
    for(var i in this.soundtracks){
      this.soundtracks[i].stop();
    }
  },
  disabled: true
}

class Soundtrack {
  constructor(howls){
    this.tracks = howls;
    this.playing = null;
    this.shouldContinue = true;
  }
  playRandom(){
    var track = this.tracks[Math.floor(Math.random()*this.tracks.length)];
    this.id = track.play();
    this.playing = track;
    track.on('end', ()=>{
      track.stop();
      if(this.shouldContinue) this.playRandom();
      else this.playing = null;
    }, this.id);
    return track;
  }
  stop(){
    if(this.playing) this.playing.fade(1, 0, 1000, this.id);
    this.shouldContinue = false;
    return this;
  }
  start(){
    if (window.music.disabled) return;
    window.music.playingSoundtrack = this;
    this.shouldContinue = true;
    for(var i in window.music.soundtracks){
      if(window.music.soundtracks[i] != this) window.music.soundtracks[i].stop();
    }
    if(this.playing) this.playing.fade(0, 1, 1000, this.id);
    else this.playRandom();
    return this;
  }
  next(name){
    this.playing.on('end', ()=>{
      window.music.soundtracks[name].start();
    }, this.id);
    return window.music.soundtracks[name];
  }
}

window.music.soundtracks.start = new Soundtrack([
  //What Are You Doing Here?
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/what%20are%20you%20doing%20here.mp3']
  })
])

window.music.soundtracks.safe = new Soundtrack ([
  //The Safe Zone
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/the%20safe%20zone.mp3?v=1664325505657']
  }),
  //Economy
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/economy.mp3?v=1664325502003']
  })
])

window.music.soundtracks.world = new Soundtrack([
  //An Absolutely Abominable Placeholder
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/an%20absolutely%20abominable%20placeholder.mp3']
  }),
  //The Other Exploration Theme
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/the%20other%20exploration%20theme.mp3']
  })
]);

window.music.soundtracks.fight = new Soundtrack([
  //Good Yet Terrible Advice
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/good%20yet%20terrible%20advice.mp3']
  })
]);

window.music.soundtracks.boss = new Soundtrack([
  //It's The Boss!
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/its%20the%20boss.mp3?v=1664402371844']
  })
]);

window.music.soundtracks.death = new Soundtrack([
  //Now You Are Dead
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/now%20you%20are%20dead.mp3']
  })
]);

window.music.soundtracks.quest = new Soundtrack([
  //On A Quest
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/on%20a%20quest.mp3?v=1664406071824']
  })
]);

export default window.music;