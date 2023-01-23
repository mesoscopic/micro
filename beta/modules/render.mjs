import util from './commonfunctions.mjs'

function renderTitle(world){
	var worldcopy=world.gameworld[0];
	if(world.wanderer.exists && world.wanderer.pos[1]==0){
		worldcopy=util.stringReplaceAt(worldcopy, world.wanderer.pos[0], world.wandererChar)
	}
	if(world.player.pos[1]==0){
		worldcopy=util.stringReplaceAt(worldcopy, world.player.pos[0], world.playerChar);
	}
	$('#beginning').text(worldcopy.replaceAll(' ','&nbsp;'));
}
function renderBody(world){
	var worldcopy=world.gameworld.slice(1);
	if(world.wanderer.exists && world.wanderer.pos[1]>0){
		worldcopy[world.wanderer.pos[1]-1]=util.stringReplaceAt(worldcopy[world.wanderer.pos[1]-1], world.wanderer.pos[0], world.wandererChar);
	}
  for(let i in world.camps){
    worldcopy[world.camps[i].pos[1]-1]=util.stringReplaceAt(worldcopy[world.camps[i].pos[1]-1], world.camps[i].pos[0], world.campChar);
  }
	if(world.player.pos[1]>0){
		worldcopy[world.player.pos[1]-1]=util.stringReplaceAt(worldcopy[world.player.pos[1]-1], world.player.pos[0], world.playerChar);
	}
	$('#gameworld').html(worldcopy.join('<br>').replaceAll(' ','&nbsp;'));
}
function renderInventory(world){
	$('#inventory').html('');
	for(var i in world.player.inventory){
		if(world.player.inventory[i].discovered == false){continue;}
		$('#inventory').append(i+": "+util.numberToCircles(world.player.inventory[i].quantity)+"<br>");
	}
	for(var j=0; j<world.world.unemployedWorkers; j++){
		$('#inventory').append('▣');
	}
}
function renderWorkshops(world){
	$('#workshops').html('');
	for(var i in world.world.workshops){
		if(world.gameworld[world.player.pos[1]][world.player.pos[0]] != i){continue;}
		var workshop = world.world.workshops[i];
		$('#workshops').append(`<hr><h3>${i}:</h3><br>▣ = ${workshop.product}<br>`);
		for(var j in workshop.LEVELS){
			if(j<0){continue;}
			if(workshop.level >= j){
				$('#workshops').append('◆');
			} else {
				$('#workshops').append('◇');
			}
		}
		$('#workshops').append('<br>');
		var meetsAllRequirements=true;
    var hasNextLevel = !(workshop.level+1 == workshop.LEVELS.length);
		if(hasNextLevel){ //If there is a next level
			for(var j in workshop.LEVELS[workshop.level+1].requirements){
				var requirement = workshop.LEVELS[workshop.level+1].requirements[j]
				$('#workshops').append(j+':'+util.numberToCircles(requirement)+'<br>');
				if(world.player.inventory[j].quantity<requirement){
					meetsAllRequirements=false;
				}
			}
			if(meetsAllRequirements){
				$('#workshops').append('<p>␣ = ◆</p>');
			}
		}
		for(var k = 0; k<workshop.LEVELS[workshop.level].workerSlots; k++){
			if(workshop.workers>=k+1){
				$('#workshops').append('▣');
			}else{
				$('#workshops').append('□');
			}
		}
		if((!meetsAllRequirements || !hasNextLevel) && world.world.unemployedWorkers>0 && workshop.workers<workshop.LEVELS[workshop.level].workerSlots){
			$('#workshops').append('<p>␣ = ▣</p>');
		}
	}
	if(world.gameworld[world.player.pos[1]][world.player.pos[0]] == '●'){
		$('#workshops').append('<hr><h3>●:</h3><br>◇<br>');
		$('#workshops').append('▭:'+util.numberToCircles(world.world.expansionCost));
		if(world.player.inventory['▭'].quantity>=world.world.expansionCost){
			$('#workshops').append('<p>␣ = ◆</p>');
		}
	}
}
function renderEntityMenu(world){
	$('#entity').html('');
	if(world.wanderer.exists && world.wanderer.pos[0] == world.player.pos[0] && world.wanderer.pos[1] == world.player.pos[1]){
		$('#entity').append('<hr>▣:<br>');
		if(world.wanderer.hireCost>0){
			$('#entity').append('◊:'+util.numberToCircles(world.wanderer.hireCost));
		}
		if(world.player.inventory['◊'].quantity>=world.wanderer.hireCost){
			$('#entity').append('<br>␣ = ▣');
		}
	}
  for(var i in world.camps){
    let camp = world.camps[i];
    if(camp.pos[0] == world.player.pos[0] && camp.pos[1] == world.player.pos[1]) {
      $('#entity').append('<hr>\u2B22:<br>␣ = ◈►\u2B22');
    }
  }
}
function renderMarket(world){
	$('#market').html('');
	if(world.gameworld[world.player.pos[1]][world.player.pos[0]] == '▦'){
		$('#market').append('<hr>▦:<br>');
		for(var i in world.world.marketplace.trades){
			var trade = world.world.marketplace.trades[i];
			var hasAllItems = true;
			var costString = '';
			var returnString = '';
			if(trade.locked){hasAllItems=false;}
			for(var j in trade.cost){
				costString+=j+' '+util.numberToCircles(trade.cost[j])+' ';
				if(world.player.inventory[j].quantity<trade.cost[j]){
					hasAllItems = false;
				}
			}
			for(var j in trade.return){
				returnString+=j+' '+util.numberToCircles(trade.return[j])+' ';
			}
			if(hasAllItems){
				$('#market').append(i+': '+costString+'-> '+returnString);
			} else if (!trade.locked) {
        $('#market').append('&nbsp;&nbsp;&nbsp;'+costString+'-> '+returnString);
      }
			$('#market').append('<br>')
		}
	}
}
function renderArmory(world){
	$('#armory').html('');
	if(world.gameworld[world.player.pos[1]][world.player.pos[0]] == '◳'){
		$('#market').append('<hr>◳:<br>');
		$("#market").append('<br>◆:<br>');
		$("#market").append(util.numberToCircles(world.player.health)+' / '+util.numberToCircles(world.player.maxHealth)+'<br>');
		if(world.player.maxHealth < 30){
			var cost = world.getArmoryUpgradeCost('health');
			var costString = '';
			var hasAllItems = true;
			for(var j in cost){
				costString+=j+' '+util.numberToCircles(cost[j])+' ';
				if(world.player.inventory[j].quantity<cost[j]){
					hasAllItems = false;
				}
			}
			$("#market").append(costString+"<br>");
			if(hasAllItems){$("#market").append("0 = ◆");}
		}
		$("#market").append('<br>►:<br>'+util.numberToTriangles(world.player.dmg)+'<br>');
		if(world.player.dmg < 4){
			var cost = world.getArmoryUpgradeCost('damage');
			var costString = '';
			var hasAllItems = true;
			for(var j in cost){
				costString+=j+' '+util.numberToCircles(cost[j])+' ';
				if(world.player.inventory[j].quantity<cost[j]){
					hasAllItems = false;
				}
			}
			$("#market").append(costString+"<br>");
			if(hasAllItems){$("#market").append("1 = ►");}
		}
    $("#market").append('<br>◮:<br>'+util.numberToCooldown(world.player.dodgeCooldown/100)+'<br>');
		if(world.player.dodgeCooldown > 500){
			var cost = world.getArmoryUpgradeCost('cooldown');
			var costString = '';
			var hasAllItems = true;
			for(var j in cost){
        if(cost[j] == 0) continue;
				costString+=j+' '+util.numberToCircles(cost[j])+' ';
				if(world.player.inventory[j].quantity<cost[j]){
					hasAllItems = false;
				}
			}
			$("#market").append(costString+"<br>");
			if(hasAllItems){$("#market").append("2 = ▨ X");}
		}
	}
}
function renderTeleport(world){
	$("#teleport").html('');
	if(world.gameworld[world.player.pos[1]][world.player.pos[0]] == '◌'){
		$("#teleport").append('<hr>◌:<br>◌ ●<br>=<br>◈◌ -> ◌');
	}
}

function render(world){
	renderTitle(world);
	renderBody(world);
	renderInventory(world);
	renderWorkshops(world);
	renderEntityMenu(world);
	renderMarket(world);
	renderArmory(world);
  renderTeleport(world);
}

export default render;