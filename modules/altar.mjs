import render from './render.mjs'
import initCombat from './combat.mjs'
import music from './music.mjs'

export default function altarUI(world){
	$('#current-cutscene').html('<use href="#altar">');
	$('#cutscene-overlay').show();
	world.cutscene=true;
	world.cutsceneControls = function(c){
		if(c==15){
			world.cutscene = false;
			clearInterval(obfuscate);
			$('#cutscene-overlay').hide();
			$("#swdesc").text(originaltext);
		} else if(c==5){
			if(world.player.inventory['◊'].quantity<12){return;}
			if(world.player.inventory['◊'].quantity<24&&(fs=='◊'||ss=='◊'||ts=='◊')){return;}
			if(world.player.inventory['◊'].quantity<36&&((fs=='◊'&&ss=='◊')||(fs=='◊'&&ts=='◊')||(ss=='◊'&&ts=='◊'))){return;}
			if(sacrificecounter==0){
				sofs = false;
				fs = '◊';
				$("#firstsacrifice").text(fs);
				sacrificecounter++;
			} else if(sacrificecounter==1){
				soss = false;
				ss = '◊';
				$("#secondsacrifice").text(ss);
				sacrificecounter++;
			} else if(sacrificecounter==2){
				sots = false;
				ts = '◊';
				$("#thirdsacrifice").text(ts);
				sacrificecounter=0;
			}
		} else if(c==6){
			if(world.player.inventory['◎'].quantity<8){return;}
			if(world.player.inventory['◎'].quantity<16&&(fs=='◎'||ss=='◎'||ts=='◎')){return;}
			if(world.player.inventory['◎'].quantity<24&&((fs=='◎'&&ss=='◎')||(fs=='◎'&&ts=='◎')||(ss=='◎'&&ts=='◎'))){return;}
			if(sacrificecounter==0){
				sofs = false;
				fs = '◎';
				$("#firstsacrifice").text(fs);
				sacrificecounter++;
			} else if(sacrificecounter==1){
				soss = false;
				ss = '◎';
				$("#secondsacrifice").text(ss);
				sacrificecounter++;
			} else if(sacrificecounter==2){
				sots = false;
				ts = '◎';
				$("#thirdsacrifice").text(ts);
				sacrificecounter=0;
			}
		} else if(c==7){
			if(world.player.inventory['◒'].quantity<4){return;}
			if(world.player.inventory['◒'].quantity<8&&(fs=='◒'||ss=='◒'||ts=='◒')){return;}
			if(world.player.inventory['◒'].quantity<12&&((fs=='◒'&&ss=='◒')||(fs=='◒'&&ts=='◒')||(ss=='◒'&&ts=='◒'))){return;}
			if(sacrificecounter==0){
				sofs = false;
				fs = '◒';
				$("#firstsacrifice").text(fs);
				sacrificecounter++;
			} else if(sacrificecounter==1){
				soss = false;
				ss = '◒';
				$("#secondsacrifice").text(ss);
				sacrificecounter++;
			} else if(sacrificecounter==2){
				sots = false;
				ts = '◒';
				$("#thirdsacrifice").text(ts);
				sacrificecounter=0;
			}
		} else if(c==8){
			if(world.player.inventory['◩'].quantity<16){return;}
			if(world.player.inventory['◩'].quantity<32&&(fs=='◩'||ss=='◩'||ts=='◩')){return;}
			if(world.player.inventory['◩'].quantity<48&&((fs=='◩'&&ss=='◩')||(fs=='◩'&&ts=='◩')||(ss=='◩'&&ts=='◩'))){return;}
			if(sacrificecounter==0){
				sofs = false;
				fs = '◩';
				$("#firstsacrifice").text(fs);
				sacrificecounter++;
			} else if(sacrificecounter==1){
				soss = false;
				ss = '◩';
				$("#secondsacrifice").text(ss);
				sacrificecounter++;
			} else if(sacrificecounter==2){
				sots = false;
				ts = '◩';
				$("#thirdsacrifice").text(ts);
				sacrificecounter=0;
			}
		} else if(c==9){
			if(world.player.inventory['▴'].quantity<2){return;}
			if(world.player.inventory['▴'].quantity<4&&(fs=='▴'||ss=='▴'||ts=='▴')){return;}
			if(world.player.inventory['▴'].quantity<6&&((fs=='▴'&&ss=='▴')||(fs=='▴'&&ts=='▴')||(ss=='▴'&&ts=='▴'))){return;}
			if(sacrificecounter==0){
				sofs = false;
				fs = '▴';
				$("#firstsacrifice").text(fs);
				sacrificecounter++;
			} else if(sacrificecounter==1){
				soss = false;
				ss = '▴';
				$("#secondsacrifice").text(ss);
				sacrificecounter++;
			} else if(sacrificecounter==2){
				sots = false;
				ts = '▴';
				$("#thirdsacrifice").text(ts);
				sacrificecounter=0;
			}
		} else if(c==10){
			if(world.world.unemployedWorkers==0){return;}
			if(world.world.unemployedWorkers==1&&(fs=='▣'||ss=='▣'||ts=='▣')){return;}
			if(world.world.unemployedWorkers==2&&((fs=='▣'&&ss=='▣')||(fs=='▣'&&ts=='▣')||(ss=='▣'&&ts=='▣'))){return;}
			if(sacrificecounter==0){
				sofs = false;
				fs = '▣';
				$("#firstsacrifice").text(fs);
				sacrificecounter++;
			} else if(sacrificecounter==1){
				soss = false;
				ss = '▣';
				$("#secondsacrifice").text(ss);
				sacrificecounter++;
			} else if(sacrificecounter==2){
				sots = false;
				ts = '▣';
				$("#thirdsacrifice").text(ts);
				sacrificecounter=0;
			}
		} else if(c==4){
			if(ts==""){
				return;
			}
			boss([fs, ss, ts], world);
			clearInterval(obfuscate);
			$("#swdesc").text(originaltext);
		}
	}
	var originaltext = $("#swdesc").text();
	var sofs = true, soss = true, sots = true;
	var fs = '', ss = '', ts = '';
	var sacrificecounter = 0;
	var obfuscate = setInterval(function(){
		var chars = "■◀□▱◁◒▲◂▣△◃▤▴◄▥▵◅▦▶◆▧▷◇▨▸◈▩▹◉▪►◊▫▻○▬▼◌▭▽◍▮▾◎▯▿●◐◠◰◑◡◱◒◢◲◓◣◳◔◤◴◕◥◵◖◦◶◗◧◷◘◨◸◙◩◹◚◪◺◛◫◻◜◬◼◝◭◽◞◮◾◟◿";
		$("#swdesc").text(originaltext.replace(/\?/g, ()=>chars[Math.floor(Math.random()*chars.length)]));
		if(sofs) $("#firstsacrifice").text(chars[Math.floor(Math.random()*chars.length)]);
		if(soss) $("#secondsacrifice").text(chars[Math.floor(Math.random()*chars.length)]);
		if(sots) $("#thirdsacrifice").text(chars[Math.floor(Math.random()*chars.length)]);
	}, 10);
}

function boss(sacrifices, world){
  var amounts = {
    '◊': 12,
    '◎': 8,
    '◒': 4,
    '◩': 16,
    '▴': 2
  }
	for(var i in sacrifices){
		if(sacrifices[i]=="▣"){
			world.world.unemployedWorkers--;
		} else {
			world.player.inventory[sacrifices[i]].quantity-=amounts[sacrifices[i]];
		}
	}
	render(world);
	var difficulty = 2;
	var values = {
		"◊":2,
		"◎":1,
		"◒":4,
		"◩":3,
		"▴":3,
		"▣":4
	}
	for(var i in sacrifices){
		difficulty += values[sacrifices[i]];
	}
	var bossDamage = Math.floor((difficulty - 2)/sacrifices.length);
	var bossHealth = difficulty*2;
  music.soundtracks.boss.start();
  initCombat(world, {
    enemyHealth: bossHealth,
    enemyDamage: bossDamage,
    enemySpeed: 1000 + Math.floor(Math.random()*200),
    win: function(world, playerHealth){
      world.player.health = playerHealth;
      if(!world.world.discoveredEnemies){
        world.world.discoveredEnemies = true;
        world.startQuest("wall");
      }
      music.soundtracks.world.start();
    },
    lose: function(world){
      for(var i in world.player.inventory){
        world.player.inventory[i].quantity = 0;
      }
      world.player.pos = [0, 0];
      render(world);
      music.soundtracks.death.start().next('safe');
    },
    loot: true,
    lootTable: [
      {
        item: "◎",
        weight: 
        sacrifices.includes('◎')||sacrifices.includes('◊')
          ? times('◎', sacrifices)+times('◊', sacrifices)>=2
            ? 9
            : 5
          : 0
      },
      {
        item: "◒",
        weight: 
        sacrifices.includes('◎')||sacrifices.includes('◒')
          ? times('◎', sacrifices)+times('◒', sacrifices)>=2
            ? 12
            : 8
          : 0
      },
      {
        item: "▴",
        weight: 
        sacrifices.includes('▴')||sacrifices.includes('◩')
          ? times('◩', sacrifices)+times('▴', sacrifices)>=2
            ? 6
            : 3
          : 0
      },
      {
        item: "▣",
        weight: 
        sacrifices.includes('▴')||sacrifices.includes('▣')
          ? 2
          : 0
      },
      {
        item: "◌",
        weight: 
        sacrifices.includes('◒')&&sacrifices.includes('▣')
          ? 4
          : 0
      },
      {
        item: "◊",
        weight: 
        sacrifices.includes('◊')||sacrifices.includes('◩')
          ? times('◩', sacrifices)+times('◊', sacrifices)>=2
            ? 12
            : 8
          : 0
      }
    ],
    lootRolls: Math.floor(
      (difficulty/4) +
      (sacrifices.includes('◎') || sacrifices.includes('◊') ? times('◎', sacrifices) + times('◊', sacrifices) >= 2 ? 7 : 5 : 0) +
      (sacrifices.includes('◎') || sacrifices.includes('◒') ? times('◎', sacrifices) + times('◒', sacrifices) >= 2 ? 8 : 5 : 0) +
      (sacrifices.includes('▴') || sacrifices.includes('◩') ? times('▴', sacrifices) + times('◩', sacrifices) >= 2 ? 5 : 3 : 0) +
      (sacrifices.includes('▴') || sacrifices.includes('▣') ? 1 : 0) +
      (sacrifices.includes('◒') && sacrifices.includes('▣') ? 3 : 0) +
      (sacrifices.includes('◊') || sacrifices.includes('◩') ? times('◊', sacrifices) + times('◩', sacrifices) >= 2 ? 7 : 4 : 0)
    ),
    handleLoot: function(item){
      if(item=="▣"){
        world.world.unemployedWorkers++;
        return true; //tells the engine loot was handled
      }
      if(item=="◌"){
        if(!world.world.discoveredFragments){
          world.world.discoveredFragments = true;
          world.startQuest('warp');
        }
        return false; //continue with normal handling, though
      }
    },
    enemyCanDodge: true
  });
}
function times(item, array){
  let appearance = 0; //This is the default value
  array.forEach(index=>{
    if (index === item) appearance++
  });
  return appearance;
}