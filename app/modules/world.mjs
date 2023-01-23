import render from './render.mjs'
import music from './music.mjs'
import menu from './menu.mjs'
import startCombat from './encounter.mjs'
import doTutorial from './combattutorial.mjs'
import startWallQuestCutscene from './wallquest.mjs'
import startWarpQuestCutscene from './warpquest.mjs'
import altarUI from './altar.mjs'
import util from './commonfunctions.mjs'
import doWarp from './warp.mjs'
import {version, checkVersion} from './version.mjs'

class World{
	constructor(savename){
    debugger;
    this.savename = savename;
		if(localStorage.getItem('micro__'+savename)){
			var loadedGame = JSON.parse(localStorage.getItem('micro__'+savename));
		} else {
			var loadedGame = {map:[],gameworld:[],player:{},wanderer:{},world:{},version: version,tags:[]}
		}
    this.tags=$.extend([], loadedGame.tags);
		this.map=$.extend([
			'■■◬■■▭■◊■●■■■▭■▭',
			'■■■■●■■■■■■■■■■■■■■■■■■■▦■■■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□◊□□□       □□□□□□□□□□    □□□□□□□□□□□□▭□□□□□□□□□□□□□□□□□□□□□□□□□□□□◊□□□',
			'■●■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■▥■□□□□□□▭□□□□□□□□□□□□□□□     □□□□□□□□□□□  □□◌□□□□□□□□□□□□□□□□□□□□□▭□□□□□□□□□□□□□□□□□□□□□',
			'■■■■■●■■◊■■■■■■■■■■■■◘■■■■■■■◊■■■■■■■■■■■□□■□□□□□□□□□□□□□□□□□□□□      □◇□□□□□□     □□□□□□□□□□▭□□□□□□□□□□□□□□□□□□□□◊□□□□□□□□□□□□□',
			'■■●■□■■■■■□□□■■■■□■■■■■◊■■■■■■▭■■■■■■■■■■■■■□□□□□□□□□□□▭□□□□□□□□   □□□□□□□□□□   □□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□▭□□□□□□□□□',
			'□□□●□□□□□□□□□□□□□□□□□□□□□□□■□□□□□□□□□□□□□□□■□□□□◳□□◊□□□□□□□□□□□□               □□□□□□□□□□□□▭□□□□□□□□□□□□□□◊▭□WIP□□□□□□□□□□□□□□□□',
			'□□□□□□□●□□□□□□□□□□□□▭□□□□□□□□□□□□□□□□□□□□□□▭□□□□□□□□□◊□□□□□□□□□□□□□□□□□▩▩□□□□□□□□□□□□□□□□□□□□□□□□□□□□□◊□□□□□□□□□□□□□□□□□□□□□□□□□',
			'□□□□●□□□□□□□◊□□□□□□◍□□□□□□□□□□□□□▭□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□▩▩□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□',
			'□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□◊□□□□□□□□□□□▩▩□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□●',
      '□□□□□◊□□□□□□□□□□□□□□□□□□□□□□□□□□◊□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□    □□□□□□□▭□□□□□□□□◊□□□□□□□□□□□□□□□□□□□□□□■■■■■■■■■■■■■■●',
      '□□□□□□□□      □□□□□□□□□□◊□□□□□  □□▭▭□□□□□□□□□□□□□□□◊□□□□□□    □□□▩▩ ▩▩▩  ▩  ▩▩▩□□□□□□□□□□□□□□□■■■■■■■■■■■■■■■■■■■●■■■■■■■■■■■■■■',
      '□□□□□         □   □□□□□□□□             □□□□□□□□□    □□□□□□    ▩▩▩■■■■■■■■■■■■■▩▩▩□□□□■■■■■■■■●■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■',
      '□  □                □□                     □   □      □ ◇     ▩▩■■■■■■■◇■■■■■■■▩ ■■■●■◇■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■',
      '                                                              ▩■■■■■■■■■■■■■■■■▩ ●■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■',
      '              □□□□□□□□□                    □□□                 ▩▩▩   ▩▩▩▩▩▩▩ ▩▩  □□□□●□□□□□■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■',
      '            □□□□□□□□□□□□             □□□    □□□□□□                 □□□▩▩□□□□□□□□□□□□□□□□▭□□□□●□□□□□□□□□□□□□□□□□□■■■■■■■■■■■■■■■■',
      '   □□□       □□□□□□  □□□□□□           □□□□□□□□□□              □□□□□□□□▩▩□□□□□□□▭□□□□□□□□□□□□◊◊□□□□□□□□□□□□□□□□□●□□□□▭□□□□□□□□□□□',
      '□□□□ □□       □□□□□□   □□     □  □  □  □□    □□□□□□□ □ □□     □□□□□□□□▩▩□□□□□□□□□□□□□□□□□●□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□',
      '□□□  □□□□       □             □□□□□ □□□       □□□□□□□□  □□    □□□□□□□□□▩□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□●□□□',
      '□□□□□□□ □                    □□□□□□□□ □□    □□□□     □□□□     □□□□□□□□▩▩□□□□□□□□□□□□□□●□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□',
      '    □□□□□□    □□           □□□□□□      □□□□□□□    □    □      □□□□□□□□▩▩□□□●□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□',
      ' □□□□        □□□□□□           □□□□□□□□      □□□□□□□   □□□□□   □□□□□□□□▩◇□□□□□□□□□□□□□□□□□□□□□□□□□●□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□',
      '  □            □□□             □□□□□□        □            □□  □□□□□□□□▩▩□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□'
		], loadedGame.map);
		this.gameworld=$.extend([
			'■■◬■■▭■◊■●■■■▭■▭'
		], loadedGame.gameworld);
		this.playerChar='◈';
		this.wandererChar='▣';
		this.player=$.extend(true, {
			pos:[0,0],
			inventory:{
				"▭":{
					discovered:false,
					quantity:0
				},
				"◊":{
					discovered:false,
					quantity:0
				},
				"◎":{
					discovered:false,
					quantity:0
				},
				"▢":{
					discovered:false,
					quantity:0
				},
				'◩':{
					discovered:false,
					quantity:0
				},
				'▩':{
					discovered:false,
					quantity:0
				},
				'▴':{
					discovered:false,
					quantity:0
				},
				'◒':{
					discovered:false,
					quantity:0
				},
				"◌":{
					discovered:false,
					quantity:0
				}
			},
			maxHealth:10,
			health:10,
			dmg:1,
      dodgeCooldown: 1000
		}, loadedGame.player);
		this.wanderer=$.extend(true, {exists:true, pos:[11, 0], hireCost:0}, loadedGame.wanderer);
		this.world=$.extend(true, {
			expansionCost:4,
			workshops:{
				'◬':{
					level:-1,
					rectangles:0,
					workers:0,
					product:'▭',
					LEVELS:[{requirements:{'▭':3,'◊':1},workerSlots:2},{requirements:{'▭':7,'◊':2},workerSlots:3},{requirements:{'▭':13,'◊':3},workerSlots:4}]
				},
				'▥':{
					level:-1,
					roundedSquares:0,
					workers:0,
					product:'▢',
					LEVELS:[{requirements:{'▭':12,'◊':3}, workerSlots:1}, {requirements:{'▭':20,'◊':4,'▢':6},workerSlots:2}, {requirements:{'▭':20,'◊':4,'▢':12}, workerSlots:3}, {requirements:{'▭':28,'◊':6,'▢':20}, workerSlots:4}]
				},
				'◘':{
					level:-1,
					halfShadedSquares:0,
					workers:0,
					product:'◩',
					LEVELS:[{requirements:{'▢':12, '▭':24}, workerSlots:1}, {requirements:{'▢':18, '◊':2, '◩':8}, workerSlots:2}, {requirements:{'▢':24, '◩':20}, workerSlots:3}]
				}
			},
			unemployedWorkers:0,
			marketplace:{
				trades:[
					{
						cost:{
							'▭':4
						},
						return:{
							'◎':1
						}
					},
					{
						cost:{
							'◎':2
						},
						return:{
							'◊':1
						}
					},
					{
						cost:{
							'▢':2
						},
						return:{
							'◎':1
						}
					},
					{
						cost:{
							'◊':4,
							'◩':8
						},
						return:{
							'▩':1
						},
						locked:true
					}
				]
			},
			discoveredEnemies:false,
			completedWallQuest:false,
      discoveredFragments:false,
      warpQuestStage: 0
		}, loadedGame.world);
    this.camps=$.extend([], loadedGame.camps);
		this.world.workshops['◬'].LEVELS[-1]={workerSlots:0}
		this.world.workshops['▥'].LEVELS[-1]={workerSlots:0}
		this.world.workshops['◘'].LEVELS[-1]={workerSlots:0}
		this.cutscene = false;
		render(this);
    
    checkVersion(loadedGame.version, this);
    
    if(this.gameworld.length == 4 && !this.world.didTutorial){
      doTutorial(this);
    }
    var time = 0;
    this.incomeTimer = setInterval(()=>{
      time = time==10?0:time+1;
      $('#gametime').text(
        time==0?'□□□□□□□□□□':
        time==1?'■□□□□□□□□□':
        time==2?'■■□□□□□□□□':
        time==3?'■■■□□□□□□□':
        time==4?'■■■■□□□□□□':
        time==5?'■■■■■□□□□□':
        time==6?'■■■■■■□□□□':
        time==7?'■■■■■■■□□□':
        time==8?'■■■■■■■■□□':
        time==9?'■■■■■■■■■□':
        time==10?'■■■■■■■■■■ saved':"Darn it. If you're seeing this, it's a bug."
      );
      if(time==10){
        this.applyIncome();
        this.saveGame();
      }
    }, 1000);
    if(this.wanderer.exists){
      setTimeout(()=>this.killWanderer(), Math.floor(Math.random()*5000+20000));
    }
    setTimeout(()=>this.spawnWanderer(), Math.floor(Math.random()*10000+60000));
	}
	move(dir){
		if(dir==0 && this.explorableSpaceAt(this.player.pos[0]-1, this.player.pos[1])){ //Moving left and space exists to the left
			this.player.pos[0]--;
		} else if(dir==1 && this.explorableSpaceAt(this.player.pos[0]+1, this.player.pos[1])){ //Moving right and space exists to the right
			this.player.pos[0]++;
		} else if(dir==2 && this.explorableSpaceAt(this.player.pos[0], this.player.pos[1]-1)){ //Moving up and space exists upward
			this.player.pos[1]--;
		} else if(dir==3 && this.explorableSpaceAt(this.player.pos[0], this.player.pos[1]+1)){ //Moving down and space exists downward
			this.player.pos[1]++;
		}
		this.doSpace(this.player.pos[0],this.player.pos[1]);
		render(this);
	}
	explorableSpaceAt(x, y){
		try{
			return this.gameworld[y][x] != ' ' && this.gameworld[y][x] != undefined && this.gameworld[y][x] != '▩';
		} catch (e) {
			//Do nothing. This will often happen when the player tries to move into a nonexistent space.
		}
	}
	doSpace(x, y){
		if((this.gameworld[y][x] == '▣') && (y == 3) && (x == 32)){
			startWallQuestCutscene(this);
		}
    if((this.gameworld[y][x] == '▣') && (y == 7) && (x == 68)){
			startWarpQuestCutscene(this);
		}
		if(this.gameworld[y][x] == '▭'){ //Add rectangle to inventory
			this.player.inventory['▭'].discovered=true;
			this.player.inventory['▭'].quantity++;
      util.replaceTile(x, y, (x>42 || y>4)?'□':'■', this)
		} else if(this.gameworld[y][x] == '◊'){ //Add lozenge to inventory
			this.player.inventory['◊'].discovered=true;
			this.player.inventory['◊'].quantity++;
			util.replaceTile(x, y, (x>42 || y>4)?'□':'■', this)
		} else if(this.gameworld[y][x] == '◬'){ //Get rectangles from rectangle workshop
			this.player.inventory['▭'].discovered=true;
			this.player.inventory['▭'].quantity += this.world.workshops['◬'].rectangles;
			this.world.workshops['◬'].rectangles=0;
		} else if(this.gameworld[y][x] == '▥'){ //Get rounded squares from rounded square workshop
			this.player.inventory['▢'].discovered=true;
			this.player.inventory['▢'].quantity += this.world.workshops['▥'].roundedSquares;
			this.world.workshops['▥'].roundedSquares=0;
		} else if(this.gameworld[y][x] == '◘'){ //Get half shaded squares from half shaded square workshop
			this.player.inventory['◩'].discovered=true;
			this.player.inventory['◩'].quantity += this.world.workshops['◘'].halfShadedSquares;
			this.world.workshops['◘'].halfShadedSquares=0;
		} else if(this.gameworld[y][x] == '◍'){ //Get half shaded squares from half shaded square workshop
			altarUI(this);
		} else if (this.gameworld[y][x] == '□' && (x>42 || y>4)/*for compability*/ && this.gameworld.length >= 4){
      if(Math.random()<0.1){
        startCombat(this);
      }
		}
    if(window.music.playingSoundtrack == window.music.soundtracks.world && (x<42 && y<4)){
      window.music.soundtracks.safe.start();
    }
    if(window.music.playingSoundtrack == window.music.soundtracks.safe && (x>42 || y>4) && this.gameworld[y][x]=='□'){
      window.music.soundtracks.world.start();
    }
    if(window.music.playingSoundtrack == window.music.soundtracks.world && (x>42 || y>4) && this.gameworld[y][x]=='■'){
      window.music.soundtracks.safe.start();
    }
	}
	applyIncome(){
		if(this.player.health<this.player.maxHealth){
      this.player.health+=((this.player.pos[0]<42 && this.player.pos[1]<4)||(this.gameworld[this.player.pos[1]][this.player.pos[0]]=='■')?2:1);
      if(this.player.health > this.player.maxHealth) this.player.health = this.player.maxHealth;
    }
		if(this.world.workshops['◬'].level >= 0){
			this.world.workshops['◬'].rectangles += this.world.workshops['◬'].workers;
		}
		if(this.world.workshops['▥'].level >= 0){
			this.world.workshops['▥'].roundedSquares += this.world.workshops['▥'].workers;
		}
		if(this.world.workshops['◘'].level >= 0){
			this.world.workshops['◘'].halfShadedSquares += this.world.workshops['◘'].workers;
		}
    if('◬▥◘'.includes(this.gameworld[this.player.pos[1]][this.player.pos[0]])){
      this.doSpace(this.player.pos[0], this.player.pos[1]);
    }
    render(this);
	}
	spaceAction(x,y){
		if(this.wanderer.exists){
			if(this.wanderer.pos[0] == this.player.pos[0] && this.wanderer.pos[1] == this.player.pos[1]){
				if(this.player.inventory['◊'].quantity<this.wanderer.hireCost){return;}
				this.wanderer.exists=false;
				this.world.unemployedWorkers++;
				this.player.inventory['◊'].quantity -= this.wanderer.hireCost;
				if(this.world.workshops['◬'].level>=0){this.wanderer.hireCost++;}
			}
		}
		if(this.gameworld[y][x] == '◬'){
			var meetsAllRequirements = true;
			var workshop = this.world.workshops['◬'];
			if(workshop.LEVELS[workshop.level+1] != undefined){
				for(var i in workshop.LEVELS[workshop.level+1].requirements){
					var requirement = workshop.LEVELS[workshop.level+1].requirements[i]
					if(this.player.inventory[i].quantity<requirement){
						meetsAllRequirements=false;
					}
				}
				if(meetsAllRequirements){
					workshop.level++;
					for(var i in workshop.LEVELS[workshop.level].requirements){
						this.player.inventory[i].quantity -= workshop.LEVELS[workshop.level].requirements[i];
					}
          render(this);
					return;
				}
			}
			if(this.world.unemployedWorkers>0 && workshop.workers<workshop.LEVELS[workshop.level].workerSlots){
				this.world.unemployedWorkers--;
				workshop.workers++;
			}
		} else if(this.gameworld[y][x] == '▥'){
			var meetsAllRequirements = true;
			var workshop = this.world.workshops['▥'];
			if(workshop.LEVELS[workshop.level+1] != undefined){
				for(var i in workshop.LEVELS[workshop.level+1].requirements){
					var requirement = workshop.LEVELS[workshop.level+1].requirements[i]
					if(this.player.inventory[i].quantity<requirement){
						meetsAllRequirements=false;
					}
				}
				if(meetsAllRequirements){
					workshop.level++;
					for(var i in workshop.LEVELS[workshop.level].requirements){
						this.player.inventory[i].quantity -= workshop.LEVELS[workshop.level].requirements[i];
					}
          render(this);
					return;
				}
			}
			if(this.world.unemployedWorkers>0 && workshop.workers<workshop.LEVELS[workshop.level].workerSlots){
				this.world.unemployedWorkers--;
				workshop.workers++;
			}
		} else if(this.gameworld[y][x] == '◘'){
			var meetsAllRequirements = true;
			var workshop = this.world.workshops['◘'];
			if(workshop.LEVELS[workshop.level+1] != undefined){
				for(var i in workshop.LEVELS[workshop.level+1].requirements){
					var requirement = workshop.LEVELS[workshop.level+1].requirements[i]
					if(this.player.inventory[i].quantity<requirement){
						meetsAllRequirements=false;
					}
				}
				if(meetsAllRequirements){
					workshop.level++;
					for(var i in workshop.LEVELS[workshop.level].requirements){
						this.player.inventory[i].quantity -= workshop.LEVELS[workshop.level].requirements[i];
					}
          render(this);
					return;
				}
			}
			if(this.world.unemployedWorkers>0 && workshop.workers<workshop.LEVELS[workshop.level].workerSlots){
				this.world.unemployedWorkers--;
				workshop.workers++;
			}
		} else if(this.gameworld[y][x] == '●'){
			if(this.player.inventory['▭'].quantity>=this.world.expansionCost){
				this.gameworld[y+1] = this.map[y+1];
				util.replaceTile(x, y, '○', this);
				this.player.inventory['▭'].quantity-=this.world.expansionCost;
				this.world.expansionCost+=4;
			}
      if(this.gameworld.length == 4) {
        doTutorial(this);
      }
		} else if(this.gameworld[y][x] == '◌' && y == 7 && x == 68){
      if(this.player.inventory['◌'].quantity>=4){
        doWarp(84, 2, this);
        this.player.inventory['◌'].quantity -= 4;
      }
    } else if(this.gameworld[y][x] == '◌' && y == 2 && x == 84){
      doWarp(68, 7, this);
    }
    render(this);
  }
	doMarketTrade(index){
		if(this.gameworld[this.player.pos[1]][this.player.pos[0]] == '▦'){
			var trade = this.world.marketplace.trades[index];
			if(trade.locked){return;}
			var hasAllItems = true;
			for(var i in trade.cost){
				if(this.player.inventory[i].quantity<trade.cost[i]){
					hasAllItems = false;
				}
			}
			if(hasAllItems){
				for(var i in trade.cost){
					this.player.inventory[i].quantity-=trade.cost[i];
				}
				for(var i in trade.return){
					this.player.inventory[i].discovered=true;
					this.player.inventory[i].quantity+=trade.return[i];
				}
			}
		} else if(this.gameworld[this.player.pos[1]][this.player.pos[0]] == '◳'){
			if(index == 0 && this.player.maxHealth < 30){
				var cost = this.getArmoryUpgradeCost('health');
				var hasAllItems = true;
				for(var i in cost){
					if(this.player.inventory[i].quantity<cost[i]){
						hasAllItems = false;
					}
				}
				if(hasAllItems){
					this.player.maxHealth++;
					for(var i in cost){
						this.player.inventory[i].quantity-=cost[i];
					}
				}
			} else if(index == 1 && this.player.dmg < 4){
				var cost = this.getArmoryUpgradeCost('damage');
				var hasAllItems = true;
				for(var i in cost){
					if(this.player.inventory[i].quantity<cost[i]){
						hasAllItems = false;
					}
				}
				if(hasAllItems){
					this.player.dmg++;
					for(var i in cost){
						this.player.inventory[i].quantity-=cost[i];
					}
				}
			} else if(index == 2 && this.player.dodgeCooldown > 500){
				var cost = this.getArmoryUpgradeCost('cooldown');
				var hasAllItems = true;
				for(var i in cost){
					if(this.player.inventory[i].quantity<cost[i]){
						hasAllItems = false;
					}
				}
				if(hasAllItems){
					this.player.dodgeCooldown-=100;
					for(var i in cost){
						this.player.inventory[i].quantity-=cost[i];
					}
				}
			}
		}
    render(this);
	}
	startQuest(questname){
		if(questname=="wall"){
			util.replaceTile(32, 3, '▣', this)
		} else if(questname=="warp"){
      util.replaceTile(68, 7, '▣', this)
    }
	}
	saveGame(){
		var savedGame = {
			map: this.map,
			gameworld: this.gameworld,
			player: this.player,
			wanderer: this.wanderer,
			world: this.world,
			version: version,
      tags: this.tags
		};
		localStorage.setItem('micro__'+this.savename, JSON.stringify(savedGame));
	}
	getArmoryUpgradeCost(stat){
		var cost = {};
		var num = (stat=='health')?this.player.maxHealth:(stat=="damage")?this.player.dmg:(this.player.dodgeCooldown/100);
		if(stat=="health"){
			if(num < 12){
				cost['▭'] = (num - 9)*8;
				cost['◊'] = num;
			} else if(num < 15){
				cost['▭'] = (num - 9)*8;
				cost['◊'] = num;
				cost['▢'] = (num - 2) * 2;
			} else if(num < 20){
				cost['▭'] = (num - 6)*8;
				cost['◊'] = num + 4;
				cost['▢'] = (num) * 2;
			} else if(num < 25){
				cost['▭'] = (num - 6)*8;
				cost['◊'] = num + 4;
				cost['▢'] = (num) * 2;
				cost['◩'] = num * 2;
			} else {
				cost['▭'] = (num - 4)*8;
				cost['◊'] = num + 4;
				cost['▢'] = (num) * 3;
				cost['◩'] = num * 2;
			}
			return cost;
		} else if(stat=="damage"){
			cost['◊'] = 4*(2**num);
			cost['◩'] = 4**num;
			return cost;
		} else if(stat=="cooldown"){
      cost['◩'] = 2**((20-num)/2);
      cost['◒'] = (num<9)?4*(20-num):0;
      cost['◌'] = (num<7)?(13-num):0;
      return cost;
    }
	}
  spawnWanderer(nocycle){
		if(this.world.completedWallQuest){
			var randomY = Math.floor(Math.random()*((this.gameworld.length>4)?4:this.gameworld.length));
			var randomX = Math.floor(Math.random()*((this.gameworld[randomY].length>42)?42:this.gameworld[randomY].length));
		}else{
			var randomY = Math.floor(Math.random()*this.gameworld.length);
			var randomX = Math.floor(Math.random()*this.gameworld[randomY].length);
		}
		if(this.gameworld[randomY][randomX] != '□' && this.gameworld[randomY][randomX] != '■'){ //Standing in the way, try again
			this.spawnWanderer();
			return;
		}
		this.wanderer.pos=[randomX,randomY];
		this.wanderer.exists=true;
    render(this);
    if(nocycle) return;
		this.wandererSpawnTimer = setTimeout(window.world.spawnWanderer.bind(window.world), Math.floor(Math.random()*10000+60000));
		this.wandererKillTimer = setTimeout(window.world.killWanderer.bind(window.world), Math.floor(Math.random()*5000+20000));
	}
	killWanderer(){
		this.wanderer.exists=false;
		render(this);
	}
  returnToMenu(){
    this.saveGame();
    music.stop();
    clearInterval(this.incomeTimer);
    clearTimeout(this.wandererSpawnTimer);
    clearTimeout(this.wandererKillTimer);
    menu().then((save)=>{
      window.world = new World(save);
      music.init();
    });
  }
}

export default World;