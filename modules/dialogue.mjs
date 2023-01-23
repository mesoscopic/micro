import util from './commonfunctions.mjs'

function startDialogue(dialogue){
  
  var tick = 0;
  var interval = setInterval(doTick, 10);
  
  function doTick(){
    var now = (dialogue.timeline??{})[tick/100] ?? [];
    now.forEach(performAction);
    if(dialogue.length == tick/100){
      clearInterval(interval);
      dialogue.finish();
    } else {
      tick++;
    }
  }
  function performAction(action){
    switch(action.type){
      case 'move':
        var me = dialogue.characters[action.target];
        var ox = me.elem.attr('x');
        var oy = me.elem.attr('y');
        util.animateAttr(me.elem, 'x', action.toX, action.time)
        util.animateAttr(me.elem, 'y', action.toY, action.time)
        if(action.speechAlsoMoves ?? true){
          util.animateAttr(me.speech, 'x', action.toX, action.time)
          util.animateAttr(me.speech, 'y', action.toY-25, action.time)
        }
        break;
      case 'speak':
        debugger;
        var me = dialogue.characters[action.target];
        var _obfi;
        me._text = action.text;
        _obfi = setInterval(function(){
          var chars = "■◀□▱◁◒▲◂▣△◃▤▴◄▥▵◅▦▶◆▧▷◇▨▸◈▩▹◉▪►◊▫▻○▬▼◌▭▽◍▮▾◎▯▿●◐◠◰◑◡◱◒◢◲◓◣◳◔◤◴◕◥◵◖◦◶◗◧◷◘◨◸◙◩◹◚◪◺◛◫◻◜◬◼◝◭◽◞◮◾◟◿";
          me.speech.text(me._text.replace(/\?/g, ()=>chars[Math.floor(Math.random()*chars.length)]));
        }, 10);
        setTimeout(function(){
          clearInterval(_obfi);
          me.speech.text('');
        }, action.time);
        break;
      case 'fade':
        var me = dialogue.characters[action.target];
        util.animateAttr(me.elem, 'opacity', action.opacity, action.time)
        if(action.speechAlsoFades ?? true){
          util.animateAttr(me.speech, 'opacity', action.opacity, action.time);
        }
        break;
      case 'scale':
        var me = dialogue.characters[action.target];
        util.animateAttr(me.elem, 'font-size', action.scale, action.time);
        break;
      case 'shake':
        var me = dialogue.characters[action.target];
        var ctime = action.time;
        var stime = action.time;
        if(action.character){
          var interval = setInterval(function(){
            ctime -= 10;
            me.elem.css({"transition": "0.1s"});
            var randomInt1 = Math.floor((Math.random() * 3) + 1);
            var randomInt2 = Math.floor((Math.random() * 3) + 1);
            var randomInt3 = Math.floor((Math.random() * 2) + 1);

            var phase1 = (randomInt1 % 2) == 0 ? "+" : "-";
            var phase2 = (randomInt2 % 2) == 0 ? "+" : "-";
            var phase3 = (randomInt3 % 2) == 0 ? "+" : "-";

            var transitionX = ((phase1 + randomInt1) * (action.amount / 10)) + "px";
            var transitionY = ((phase2 + randomInt2) * (action.amount / 10)) + "px";
            var rotate = ((phase3 + randomInt3) * (action.amount / 10)) + "deg";

            me.elem.css({"transform": "translate("+transitionX+","+transitionY+") rotate("+rotate+")"});  
            if(ctime<=0){
              clearInterval(interval);
              me.elem.css({"transform": "none"});
            }
          }, 10);
        }
        if(action.speech){
          var interval = setInterval(function(){
            me.speech.css({"transition": "0.1s"});
            stime -= 10;
            var randomInt1 = Math.floor((Math.random() * 3) + 1);
            var randomInt2 = Math.floor((Math.random() * 3) + 1);
            var randomInt3 = Math.floor((Math.random() * 2) + 1);

            var phase1 = (randomInt1 % 2) == 0 ? "+" : "-";
            var phase2 = (randomInt2 % 2) == 0 ? "+" : "-";
            var phase3 = (randomInt3 % 2) == 0 ? "+" : "-";

            var transitionX = ((phase1 + randomInt1) * (action.amount / 10)) + "px";
            var transitionY = ((phase2 + randomInt2) * (action.amount / 10)) + "px";
            var rotate = ((phase3 + randomInt3) * (action.amount / 10)) + "deg";

            me.speech.css({"transform": "translate("+transitionX+","+transitionY+") rotate("+rotate+")"});  
            if(stime<=0){
              clearInterval(interval);
              me.speech.css({"transform": "none"});
            }
          }, 10);
        }
        break;
      case 'js':
        action.run();
        break;
    }
  }
}

export default startDialogue