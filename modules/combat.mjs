import render from './render.mjs'
import util from './commonfunctions.mjs'

function startCombat(world, settings){
	var playerHealth = world.player.health || 10;
	var playerDmg = world.player.dmg || 1;
  var playerDodgeSpeed = world.player.dodgeCooldown || 1000;
	var enemyHealth = settings.enemyHealth;
	var enemyDmg = settings.enemyDamage;
  var enemySpeed = settings.enemySpeed || 1500;
  var canAttack = true;
  var canHeal = true;
  var canDodge = true;
  var isDodging = false;
  var isEnemyDodging = false;
  var hci, dci;
	rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
	$('#current-cutscene').html('<use href="#combat">');
	$('#cutscene-overlay').show();
	util.animateAttr($("#player_in_combat"), "x", 50, 500);
	util.animateAttr($("#combat_player_health"), "x", 50, 500);
	util.animateAttr($("#combat_player_dmg"), "x", 50, 500);
	util.animateAttr($("#combat_player_heal"), "x", 50, 500);
  util.animateAttr($("#combat_player_dodge"), "x", 50, 500);
	world.cutscene=true;
	world.cutsceneControls = function(control){
		if(control==5){
      if(!canAttack){return;}
      canAttack = false;
			util.animateAttr($("#player_in_combat"), "x", 150, 500, function(){
				util.animateAttr($("#player_in_combat"), "x", 50, 500, function(){
          canAttack = true;
					if(settings.winAtHealth?(enemyHealth<=settings.winAtHealth):(enemyHealth == 0)){
            canAttack = false;
            canHeal = false;
            canDodge = false;
            util.animateAttr($("#enemy_in_combat"), "opacity", settings.winAtHealth?1:0, 500, function(){
              if(settings.loot ?? true){ //We use the brand new nullish coalescing operator because "|| true" would return true every time
                var loot = doLoot(world, settings);
                $("#combat_loot").text(loot.join(""));
              }
              util.animateAttr($("#combat_loot"), "x", 50, 500, function(){resetRender(hci, dci);settings.win(world, playerHealth);});
            });
            util.animateAttr($("#combat_enemy_corpse"), "opacity", settings.winAtHealth?0:1, 500);
          }
				});
        if($('#enemy_in_combat').attr('x') >= 125 && (isDodging == isEnemyDodging)){
          enemyHealth = (enemyHealth-playerDmg)<0 ? 0 : (enemyHealth-playerDmg);
          rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
          if(settings.winAtHealth?(enemyHealth<=settings.winAtHealth):(enemyHealth == 0)){
            clearInterval(enemyAttack);
            return;
          }
        }
			});
		} else if(control==6){
      if(!canHeal){return;}
			if(world.player.inventory['▴'].quantity==0){
				return;
			}
      canHeal = false;
      var healCooldown = 5000;
      $('#combat_player_heal').text(util.numberToCooldown(healCooldown/500));
      hci = setInterval(()=>{healCooldown-=500; $('#combat_player_heal').text(util.numberToCooldown(healCooldown/500)); if(healCooldown==0){clearInterval(hci); canHeal = true; rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);}}, 500);
			world.player.inventory['▴'].quantity--;
			playerHealth += 4;
			playerHealth = (playerHealth>world.player.maxHealth)?world.player.maxHealth:playerHealth; //cap at max health
			rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
		} else if(control==7){
      if(!canDodge){return;}
      canDodge = false;
      isDodging=true;
      util.animateAttr($("#player_in_combat"), "y", 60, 250, function(){
				util.animateAttr($("#player_in_combat"), "y", 75, 250, function(){
          isDodging = false;
          var dodgeCooldown = playerDodgeSpeed;
          $('#combat_player_dodge').text(util.numberToCooldown(dodgeCooldown/100));
          dci = setInterval(()=>{dodgeCooldown-=100; $('#combat_player_dodge').text(util.numberToCooldown(dodgeCooldown/100)); if(dodgeCooldown==0){clearInterval(dci); canDodge = true; rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);}}, 100);
				});
			});
    }
	}
	var enemyAttack = setInterval(function(){
    if(settings.enemyCanDodge && Math.random()<0.4){
      isEnemyDodging = true;
      util.animateAttr($("#enemy_in_combat"), "y", 60, 250, function(){
				util.animateAttr($("#enemy_in_combat"), "y", 75, 250, function(){
          isEnemyDodging = false;
				});
			});
      return;
    }
		util.animateAttr($("#enemy_in_combat"), "x", 50, ((enemySpeed-500)==0?500:(enemySpeed-500))/2, function(){
			util.animateAttr($("#enemy_in_combat"), "x", 150, ((enemySpeed-500)==0?500:(enemySpeed-500))/2, function(){
				if(playerHealth == 0){
          $("#combat_player_corpse").attr('opacity', '1');
          util.animateAttr($("#player_in_combat"), "opacity", 0, 500, ()=>resetRender(hci, dci));
          settings.lose(world);
        }
			});
      if($('#player_in_combat').attr('x') <= 75 && (isDodging == isEnemyDodging)){
        var calculatedDamage = enemyDmg;
        if(isDodging) calculatedDamage *= 0;
        playerHealth = (playerHealth-calculatedDamage)<0 ? 0 : (playerHealth-calculatedDamage);
        rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
        if(playerHealth == 0){
          clearInterval(enemyAttack);
          return;
        }
      }
		});
	}, enemySpeed);
}

function rerender(ph, pd, eh, ed, world){
	$("#combat_player_health").text(util.numberToCircles(ph));
	$("#combat_enemy_health").text(util.numberToCircles(eh));
	$("#combat_player_dmg").text('0: '+util.numberToTriangles(pd));
	if(!$('#combat_player_heal').text().includes('▨')) $("#combat_player_heal").text((world.player.inventory['▴'].quantity>0)?'1: ▴ ('+util.numberToCircles(world.player.inventory['▴'].quantity)+')':"");
	$("#combat_enemy_dmg").text(util.numberToTriangles(ed));
  if(!$('#combat_player_dodge').text().includes('▨')) $("#combat_player_dodge").text('2: ◮');
}
function resetRender(h, d){
  world.cutscene = false;
  $('#cutscene-overlay').hide();
  $('#player_in_combat').attr('x', '-20');
	$('#player_in_combat').attr('opacity', '1');
	$('#enemy_in_combat').attr('x', '150');
	$('#enemy_in_combat').attr('opacity', '1');
	$('#combat_player_health').attr('x', '-20');
	$('#combat_player_dmg').attr('x', '-20');
	$("#combat_loot").attr('x', '150');
	$("#combat_loot").text("");
  clearInterval(h);
  clearInterval(d);
  $('#combat_player_heal').text('');
  $('#combat_player_dodge').text('');
  $('#combat_player_corpse, #combat_enemy_corpse').attr('opacity', '0');
}
function doLoot(world, settings){
	var loot = util.loot(settings.lootTable, settings.lootRolls);
	for(var i in loot){
    if(!(settings.handleLoot || function(){})(loot[i])){
      world.player.inventory[loot[i]].discovered = true;
		  world.player.inventory[loot[i]].quantity++;
    }
	}
	render(world);
	return loot;
}

export default startCombat;