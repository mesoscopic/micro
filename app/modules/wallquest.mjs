import util from './commonfunctions.mjs'
import music from './music.mjs'

function startWallQuestCutscene(world){
  music.soundtracks.quest.start();
	$('#current-cutscene').html('<use href="#wallquestintro">');
	$('#cutscene-overlay').show();
	world.cutscene=true;
	world.player.inventory['▩'].discovered=true;
	world.world.marketplace.trades[3].locked=false;
	$("#wallquestprogress").text('▩: '+util.numberToCircles(world.player.inventory['▩'].quantity));
	if(world.player.inventory['▩'].quantity>=4){
		world.cutscene = false;
		$('#cutscene-overlay').hide();
		world.player.inventory['▩'].quantity=0;
		world.world.marketplace.trades[3].locked = true;
		world.world.completedWallQuest=true;
		world.map[1] = util.stringReplaceAt(world.map[1], 42, '▩');
		world.map[2] = util.stringReplaceAt(world.map[2], 42, '▩');
		world.map[3] = util.stringReplaceAt(world.map[3], 32, '□');
		world.map[4] = world.map[4].slice(0, 43).replaceAll('□', '▩').replaceAll('■', '▩') + world.map[4].slice(43);
		if(world.gameworld[1]){world.gameworld[1]=world.map[1];}
		if(world.gameworld[2]){world.gameworld[2]=world.map[2];}
		if(world.gameworld[3]){world.gameworld[3]=world.map[3];}
		if(world.gameworld[4]){world.gameworld[4]=world.map[4];}
	}
	var enemyAttack = setInterval(function(){
		util.animateAttr($("#wallquest_enemy"), "x", 50, 500, function(){
			util.animateAttr($("#wallquest_enemy"), "x", 150, 500);
		});
	}, 1000);
	world.cutsceneControls=function(c){
		if(c==4){
			world.cutscene = false;
			clearInterval(enemyAttack);
			$('#cutscene-overlay').hide();
      music.soundtracks.quest.next('safe');
		}
	}
}

export default startWallQuestCutscene