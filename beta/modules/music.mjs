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
    this.tracks = howls.length?howls:[howls];
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

window.music.soundtracks.start = new Soundtrack(new Howl({src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/what%20are%20you%20doing%20here.mp3']}))

window.music.soundtracks.safe = new Soundtrack ([
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/the%20safe%20zone.mp3?v=1664325505657']
  }),
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/economy.mp3?v=1664325502003']
  })
])

window.music.soundtracks.world = new Soundtrack(new Howl({src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/March%20of%20the%20Foreigners.wav?v=1668042334407']}));

window.music.soundtracks.fight = new Soundtrack(new Howl({src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/good%20yet%20terrible%20advice.mp3']}));

window.music.soundtracks.boss = new Soundtrack(new Howl({src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/The%20Wager%20With%20Death.wav?v=1668042330761']}));

window.music.soundtracks.death = new Soundtrack(new Howl({src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/now%20you%20are%20dead.mp3']}));

window.music.soundtracks.quest = new Soundtrack(new Howl({src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/on%20a%20quest.mp3?v=1664406071824']}));

window.music.soundtracks.expansion = new Soundtrack(new Howl({src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/The%20Paradigm%20Widens.wav?v=1668473804244']}));

export default window.music;