import World from './modules/world.mjs'
import render from './modules/render.mjs'
import music from './modules/music.mjs'
import openCheatMenu from './modules/cheats.mjs'

$(function(){
  if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
    /*
    Now that I have a phone,
    I felt compelled to do this,
    So before it's too late (I'm looking at you, Minecraft Bedrock Edition),
    I've started development...
    Micro Mobile coming soon...
    */
    window.location.replace('/projects/micro/mobile');
  }
  var keys = [];
	$(document).keydown(function(e){
		if(e.altKey||e.ctrlKey||e.metaKey||e.shiftKey) return; //Stops app from preventing keyboard shortcuts
    if(window.menu || window.cheating) return;
		e.preventDefault(); //This is to stop the page from scrolling when your stuff overflows it
    keys.push(e.key);
    
		if(e.key=='a' || e.key=='ArrowLeft'){
			if(world.cutscene){world.cutsceneControls(0);}
			else{world.move(0);}
		} else if (e.key=='d' || e.key=='ArrowRight'){
			if(world.cutscene){world.cutsceneControls(1);}
			else{world.move(1);}
		} else if (e.key=='w' || e.key=='ArrowUp'){
			if(world.cutscene){world.cutsceneControls(2);}
			else{world.move(2);}
		} else if (e.key=='s' || e.key=='ArrowDown'){
			if(world.cutscene){world.cutsceneControls(3);}
			else{world.move(3);}
		} else if (e.key==' '){
			if(world.cutscene){world.cutsceneControls(4);}
			else{world.spaceAction(world.player.pos[0], world.player.pos[1]);}
		} else if (e.key=='0'){
			if(world.cutscene){world.cutsceneControls(5);}
			else{world.doMarketTrade(0);}
		} else if (e.key=='1'){
			if(world.cutscene){world.cutsceneControls(6);}
			else{world.doMarketTrade(1);}
		} else if (e.key=='2'){
			if(world.cutscene){world.cutsceneControls(7);}
			else{world.doMarketTrade(2);}
		} else if (e.key=='3'){
			if(world.cutscene){world.cutsceneControls(8);}
			else{world.doMarketTrade(3);}
		} else if (e.key=='4'){
			if(world.cutscene){world.cutsceneControls(9);}
		} else if (e.key=='5'){
			if(world.cutscene){world.cutsceneControls(10);}
		} else if (e.key=='6'){
			if(world.cutscene){world.cutsceneControls(11);}
		} else if (e.key=='7'){
			if(world.cutscene){world.cutsceneControls(12);}
		} else if (e.key=='8'){
			if(world.cutscene){world.cutsceneControls(13);}
		} else if (e.key=='9'){
			if(world.cutscene){world.cutsceneControls(14);}
		} else if (e.key=='r'){
			if(world.cutscene){world.cutsceneControls(15);}
      else if (keys.join('').endsWith('cheater')){openCheatMenu(world, {
        render
      });}
			else{world.returnToMenu();}
		}
	});
});