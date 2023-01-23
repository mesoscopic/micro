import util from './commonfunctions.mjs'
import music from './music.mjs'

export const version = '0.1.0';

export function checkVersion(ver, world){
  $('title').text('Micro v'+version);
  if(typeof ver == 'number') ver = '0.0.3'
  var test = compareVersions(ver, version);
  switch(+versionCheck(ver, ['0.0.3.16'])){
    case 0:
      util.replaceTile(71, 3, '◇', world);
      util.replaceTile(127, 8, '●', world);
  }
  if(!ver || (test<0)){
    $('#update').attr('open', true);
    $('#version').text($('#version').text().replace('*version*', version));
    $('#dismiss').click(()=>{
      $('#update').removeAttr('open');
    });
  }
}

export function versionCheck(version, versions){
  for(var i in versions){
    var test = compareVersions(versions[i], version);
    if(test==1) return i;
  }
}

export function compareVersions(oldv, newv) {
  let at = oldv.split('.').map((e)=>parseInt(e));
  let bt = newv.split('.').map((e)=>parseInt(e));
  
  if(at.length < 4) at.push(0);
  if(bt.length < 4) bt.push(0);
  
  if(at[0]==bt[0]){
    if(at[1]==bt[1]){
      if(at[2]==bt[2]){
        if(at[3]==bt[3]){
          return 0;
        } else {
          if(at[3]<bt[3]) return -1;
          if(at[3]>bt[3]) return 1;
        }
      } else {
        if(at[2]<bt[2]) return -1;
        if(at[2]>bt[2]) return 1;
      }
    } else {
      if(at[1]<bt[1]) return -1;
      if(at[1]>bt[1]) return 1;
    }
  } else {
    if(at[0]<bt[0]) return -1;
    if(at[0]>bt[0]) return 1;
  }
}

export function showTrailer(){
  window.trailer = true;
  const trailerURL = "https://cdn.glitch.me/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/awesome%20trailer.mp4?v=1666918203272";
  const vid = $(`<video class="trailer" autoplay><source src="${trailerURL}"></source></video>`);
  vid.appendTo('body').fadeIn(1000).on('ended', ()=>{
    vid.fadeOut(1000);
    music.init();
  });
}