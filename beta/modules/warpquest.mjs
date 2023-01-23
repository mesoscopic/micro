import util from './commonfunctions.mjs'
import startDialogue from './dialogue.mjs'
import render from './render.mjs'
import initCombat from './combat.mjs'
import music from './music.mjs'

function startWarpQuestCutscene(world){
  music.soundtracks.quest.start();
  world.cutsceneControls = () => {};
  switch(world.world.warpQuestStage){
    case 0:
      warpQuestCutscene1(world);
      break;
    case 1:
      warpQuestCutscene2(world);
      break;
    case 2:
      warpQuestCutscene3(world);
      break;
    case 3:
      warpQuestCutscene4(world);
      break;
    case 4:
      warpQuestCutscene5(world);
      break;
  }
}

function warpQuestCutscene0(world){
  startDialogue({
    length: 3.0,
    finish: ()=>{
      world.cutscene = false;
      $('#cutscene-overlay').hide();
      music.soundtracks.quest.next('world');
    },
    characters: [
      {
        elem: $('#wqc1_player'),
        speech: $('#wqc1_ps')
      },
      {
        elem: $('#wqc1_npc'),
        speech: $('#wqc1_ns')
      }
    ],
    timeline: {
      0.0: [
        {
          type: "move",
          target: 0,
          toX: 50,
          toY: 75,
          time: 1000,
          speechAlsoMoves: true
        }
      ],
      1.0: [
        {
          type: "speak",
          target: 1,
          text: "◈ ◌",
          time: 1000
        }
      ],
      2.0: [
        {
          type: "move",
          target: 0,
          toX: -20,
          toY: 75,
          time: 1000,
          speechAlsoMoves: true
        }
      ]
    }
  });
}

function warpQuestCutscene1(world){
	$('#current-cutscene').html('<use href="#warpquestcutscene1">');
	$('#cutscene-overlay').show();
	world.cutscene=true;
  if(world.player.inventory['◌'].quantity < 1){
    warpQuestCutscene0(world);
    return;
  }
  world.world.warpQuestStage = 1;
  startDialogue({
    length: 8.0,
    finish: ()=>{
      world.player.inventory['◌'].quantity--;
      startWarpQuestCutscene(world);
    },
    characters: [
      {
        elem: $('#wqc1_player'),
        speech: $('#wqc1_ps')
      },
      {
        elem: $('#wqc1_npc'),
        speech: $('#wqc1_ns')
      }
    ],
    timeline: {
      0.0: [
        {
          type: "move",
          target: 0,
          toX: 50,
          toY: 75,
          time: 1000,
          speechAlsoMoves: true
        }
      ],
      1.0: [
        {
          type: "speak",
          target: 1,
          text: "◈ ◌",
          time: 1000
        }
      ],
      2.0: [
        {
          type: "speak",
          target: 0,
          text: "◌",
          time: 1500
        }
      ],
      2.5: [
        {
          type: "move",
          target: 0,
          toX: 125,
          toY: 75,
          time: 1000,
          speechAlsoMoves: true
        }
      ],
      3.5: [
        {
          type: "speak",
          target: 1,
          text: "◌",
          time: 4500
        },
        {
          type: "move",
          target: 1,
          toX: 150,
          toY: 55,
          time: 500,
          speechAlsoMoves: true
        }
      ],
      4.0: [
        {
          type: "move",
          target: 1,
          toX: 150,
          toY: 75,
          time: 500,
          speechAlsoMoves: true
        }
      ],
      5.0: [
        {
          type: "move",
          target: 1,
          toX: 220,
          toY: 75,
          time: 1000,
          speechAlsoMoves: true
        }
      ],
      7.0: [
        {
          type: "move",
          target: 0,
          toX: 220,
          toY: 75,
          time: 1000,
          speechAlsoMoves: true
        }
      ],
      8.0: [
        {
          type: "move",
          target: 0,
          toX: -20,
          toY: 75,
          time: 0,
          speechAlsoMoves: true
        },
        {
          type: "move",
          target: 1,
          toX: 150,
          toY: 75,
          time: 0,
          speechAlsoMoves: true
        }
      ]
    }
  });
}

function warpQuestCutscene2(world){
  $('#current-cutscene').html('<use href="#warpquestcutscene2">');
  $('#cutscene-overlay').show();
  world.cutscene=true;
  world.world.warpQuestStage = 2;
  startDialogue({
    length: 14.0,
    finish: ()=>{
      startWarpQuestCutscene(world);
    },
    characters: [
      {
        elem: $('#wqc2_player'),
        speech: $('#wqc2_ps')
      },
      {
        elem: $('#wqc2_npc'),
        speech: $('#wqc2_ns')
      },
      {
        elem: $('#wqc2_ws'),
        speech: $('#wqc2_ns')
      }
    ],
    timeline: {
      1.0: [
        {
          type: "speak",
          target: 1,
          text: "◌-▩->",
          time: 1000
        },
        {
          type: "fade",
          target: 2,
          opacity: 1,
          speechAlsoFades: false,
          time: 1000
        }
      ],
      2.0: [
        {
          type: "speak",
          target: 1,
          text: "?",
          time: 500
        }
      ],
      2.5: [
        {
          type: "speak",
          target: 1,
          text: "??",
          time: 500
        },
        {
          type: "shake",
          target: 2,
          character: true,
          speech: false,
          amount: 10,
          time: 1000
        }
      ],
      3.0: [
        {
          type: "speak",
          target: 1,
          text: "???",
          time: 500
        },
        {
          type: "scale",
          time: 7000,
          scale: 400,
          target: 2
        }
      ],
      3.5: [
        {
          type: "speak",
          target: 1,
          text: "????",
          time: 500
        },
        {
          type: "shake",
          target: 2,
          character: true,
          speech: false,
          amount: 20,
          time: 1000
        }
      ],
      4.0: [
        {
          type: "speak",
          target: 1,
          text: "?????",
          time: 6000
        },
        {
          type: "shake",
          target: 2,
          character: true,
          speech: false,
          amount: 50,
          time: 1000
        },
        {
          type: "shake",
          target: 1,
          character: false,
          speech: true,
          amount: 10,
          time: 1000
        }
      ],
      5.0: [
        {
          type: "js",
          run: function(){
            $('#cutscene-overlay').fadeOut(5000);
          }
        }
      ],
      10.0: [
        {
          type: "js",
          run: function(){
            $('#cutscene-overlay').hide();
            util.replaceTile(71, 7, '□', world);
            util.replaceTile(71, 6, '□', world);
            util.replaceTile(71, 8, '□', world);
            util.replaceTile(72, 7, '□', world);
            render(world);
          }
        }
      ],
      11.0: [
        {
          type: "js",
          run: function(){
            util.replaceTile(71, 7, ' ', world);
            util.replaceTile(71, 6, ' ', world);
            util.replaceTile(71, 8, ' ', world);
            util.replaceTile(72, 7, ' ', world);
            util.replaceTile(70, 7, ' ', world);
            util.replaceTile(72, 6, '□', world);
            util.replaceTile(72, 8, '□', world);
            render(world);
          }
        }
      ],
      12.0: [
        {
          type: "js",
          run: function(){
            util.replaceTile(69, 7, ' ', world);
            util.replaceTile(70, 6, ' ', world);
            util.replaceTile(70, 8, ' ', world);
            util.replaceTile(72, 6, ' ', world);
            util.replaceTile(72, 8, ' ', world);
            util.replaceTile(73, 6, ' ', world);
            util.replaceTile(73, 7, ' ', world);
            util.replaceTile(73, 8, ' ', world);
            render(world);
          }
        }
      ],
      13.0: [
        {
          type: "js",
          run: function(){
            util.replaceTile(68, 6, ' ', world);
            util.replaceTile(69, 6, ' ', world);
            util.replaceTile(68, 8, ' ', world);
            util.replaceTile(69, 8, ' ', world);
            util.replaceTile(74, 6, ' ', world);
            util.replaceTile(75, 6, ' ', world);
            util.replaceTile(74, 7, ' ', world);
            util.replaceTile(75, 7, ' ', world);
            util.replaceTile(74, 8, ' ', world);
            util.replaceTile(75, 8, ' ', world);
            render(world);
          }
        }
      ]
    }
  });
}

function warpQuestCutscene3(world){
  $('#current-cutscene').html('<use href="#warpqueststage3">');
  $('#cutscene-overlay').show();
  world.cutscene = true;
  world.cutsceneControls = function(control){
    if(control==15){
      world.cutscene = false;
      $('#cutscene-overlay').hide();
      music.soundtracks.quest.next('world');
    }
    if(control==4){
      music.soundtracks.boss.start();
      initCombat(world, {
        enemyHealth: 40,
        enemyDamage: 4,
        enemySpeed: 1600,
        lose: function(world){
          for(var i in world.player.inventory){
            world.player.inventory[i].quantity = 0;
          }
          world.player.pos = [0, 0];
          render(world);
          music.soundtracks.death.start().next('safe');
        },
        win: function(world, playerHealth){
          world.player.health = playerHealth;
          initCombat(world, {
            enemyHealth: 1,
            enemyDamage: 4,
            enemySpeed: 500,
            lose: function(world){
              for(var i in world.player.inventory){
                world.player.inventory[i].quantity = 0;
              }
              world.player.pos = [0, 0];
              render(world);
              music.soundtracks.death.start().next('safe');
            },
            win: function(world, playerHealth){
              world.player.health = playerHealth;
              initCombat(world, {
                enemyHealth: world.player.maxHealth,
                enemyDamage: world.player.dmg,
                enemySpeed: 1500,
                enemyCanDodge: true,
                winAtHealth: 4,
                lose: function(world){
                  for(var i in world.player.inventory){
                    world.player.inventory[i].quantity = 0;
                  }
                  world.player.pos = [0, 0];
                  render(world);
                  music.soundtracks.death.start().next('safe');
                },
                win: function(world, playerHealth){
                  world.player.health = playerHealth;
                  world.world.warpQuestStage = 3;
                  startWarpQuestCutscene(world);
                },
                loot: true,
                lootTable: [
                  {
                    item: '.',
                    weight: 4
                  }
                ],
                lootRolls: 4,
                handleLoot: function(){
                  return true;
                }
              });
            },
            loot: true,
            lootTable: [
              {
                item: '.',
                weight: 4
              }
            ],
            lootRolls: 4,
            handleLoot: function(){
              return true;
            }
          });
        },
        loot: true,
        lootTable: [
          {
            item: '.',
            weight: 4
          }
        ],
        lootRolls: 4,
        handleLoot: function(){
          return true;
        }
      });
    }
  }
}

function warpQuestCutscene4(world){
  $('#current-cutscene').html('<use href="#warpqueststage4">');
  $('#cutscene-overlay').show();
  world.cutscene = true;
  world.cutsceneControls = function(control){
    if(control==15){
      world.cutscene = false;
      $('#cutscene-overlay').hide();
      world.world.warpQuestStage = 4;
      music.soundtracks.quest.next('world');
    }
  }
  startDialogue({
    length: 8.0,
    finish: function(){
      if(world.player.inventory['◌']>=8){
        world.world.warpQuestStage = 4;
        startWarpQuestCutscene(world);
      }
    },
    characters: [
      { //The dots
        elem: $('#wqs4_dots')
      },
      { //The enemy
        elem: $('#wqs4_escaper')
      },
      { //The first shard
        elem: $('#wqs4_shard1')
      },
      { //The second shard
        elem: $('#wqs4_shard2')
      },
      { //The third shard
        elem: $('#wqs4_shard3')
      },
      { //The fourth shard
        elem: $('#wqs4_shard4')
      },
      { //The portal
        elem: $('#wqs4_tp')
      },
      { //Instructions
        elem: $('#wqs4_need'),
        speech: $('#wqs4_return')
      }
    ],
    timeline: {
      0.0: [
        {
          type: "move",
          target: 1,
          toX: 150,
          toY: 50,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      1.0: [
        {
          type: "fade",
          target: 2,
          opacity: 1,
          time: 1000,
          speechAlsoFades: false
        },
        {
          type: "move",
          target: 2,
          toX: 85,
          toY: 70,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      2.0: [
        {
          type: "fade",
          target: 3,
          opacity: 1,
          time: 1000,
          speechAlsoFades: false
        },
        {
          type: "move",
          target: 3,
          toX: 115,
          toY: 70,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      3.0: [
        {
          type: "fade",
          target: 4,
          opacity: 1,
          time: 1000,
          speechAlsoFades: false
        },
        {
          type: "move",
          target: 4,
          toX: 85,
          toY: 85,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      4.0: [
        {
          type: "fade",
          target: 5,
          opacity: 1,
          time: 1000,
          speechAlsoFades: false
        },
        {
          type: "move",
          target: 5,
          toX: 115,
          toY: 85,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      5.0: [
        {
          type: "fade",
          target: 0,
          opacity: 0,
          time: 0,
          speechAlsoFades: false
        },
        {
          type: "fade",
          target: 2,
          opacity: 0,
          time: 0,
          speechAlsoFades: false
        },
        {
          type: "fade",
          target: 3,
          opacity: 0,
          time: 0,
          speechAlsoFades: false
        },
        {
          type: "fade",
          target: 4,
          opacity: 0,
          time: 0,
          speechAlsoFades: false
        },
        {
          type: "fade",
          target: 5,
          opacity: 0,
          time: 0,
          speechAlsoFades: false
        },
        {
          type: "fade",
          target: 6,
          opacity: 1,
          time: 0,
          speechAlsoFades: false
        },
        {
          type: "shake",
          target: 6,
          character: true,
          speech: false,
          amount: 10,
          time: 3000
        }
      ],
      6.0: [
        {
          type: "move",
          target: 1,
          toX: 100,
          toY: 70,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      7.0: [
        {
          type: "fade",
          target: 1,
          opacity: 0,
          time: 1000,
          speechAlsoFades: false
        }
      ],
      8.0: [
        {
          type: "fade",
          target: 7,
          opacity: 1,
          time: 0,
          speechAlsoFades: true
        }
      ]
    }
  })
}

function warpQuestCutscene5(world){
  if(world.player.inventory['◌'].quantity < 8){
    $('#current-cutscene').html('<use href="#warpqueststage4-5">');
    $('#cutscene-overlay').show();
    world.cutscene = true;
    world.cutsceneControls = function(control){
      if(control==15){
        world.cutscene = false;
        $('#cutscene-overlay').hide();
        world.world.warpQuestStage = 4;
        music.soundtracks.quest.next('world');
      }
    }
    return;
  } else {
    $('#current-cutscene').html('<use href="#warpqueststage5">');
    $('#cutscene-overlay').show();
    world.cutscene = true;
    startDialogue({
      length: 14.0,
      finish: function(){
        world.player.inventory['◌'].quantity -= 8;
        world.cutscene = false;
        $('#cutscene-overlay').hide();
        util.replaceTile(68, 7, '◌', world);
        world.player.pos = [84, 2];
        render(world);
      },
      characters: [
        { //The portal
          elem: $('#wqs5_tp')
        },
        { //The player
          elem: $('#wqs5_player')
        },
        { //The first shard
          elem: $('#wqs5_shard1')
        },
        { //The second shard
          elem: $('#wqs5_shard2')
        },
        { //The third shard
          elem: $('#wqs5_shard3')
        },
        { //The fourth shard
          elem: $('#wqs5_shard4')
        },
        { //The NPC
          elem: $('#wqs5_npc')
        }
      ],
      timeline: {
        0.0: [
          {
            type: "move",
            target: 1,
            toX: 50,
            toY: 50,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        1.0: [
          {
            type: "fade",
            target: 2,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 2,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        2.0: [
          {
            type: "fade",
            target: 3,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 3,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        3.0: [
          {
            type: "fade",
            target: 4,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 4,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        4.0: [
          {
            type: "fade",
            target: 5,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 5,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        5.0: [
          {
            type: "fade",
            target: 2,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 2,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "fade",
            target: 3,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 3,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "fade",
            target: 4,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 4,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "fade",
            target: 5,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 5,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "shake",
            target: 0,
            character: true,
            speech: false,
            amount: 10,
            time: 2000
          },
          {
            type: "move",
            target: 6,
            toX: 150,
            toY: 70,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        6.0: [
          {
            type: "fade",
            target: 6,
            opacity: 0,
            time: 1000,
            speechAlsoFades: false
          }
        ],
        7.0: [
          {
            type: "fade",
            target: 2,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 2,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        8.0: [
          {
            type: "fade",
            target: 3,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 3,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        9.0: [
          {
            type: "fade",
            target: 4,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 4,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        10.0: [
          {
            type: "fade",
            target: 5,
            opacity: 1,
            time: 1000,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 5,
            toX: 150,
            toY: 75,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        11.0: [
          {
            type: "fade",
            target: 2,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 2,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "fade",
            target: 3,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 3,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "fade",
            target: 4,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 4,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "fade",
            target: 5,
            opacity: 0,
            time: 0,
            speechAlsoFades: false
          },
          {
            type: "move",
            target: 5,
            toX: 50,
            toY: 50,
            time: 0,
            speechAlsoMoves: false
          },
          {
            type: "shake",
            target: 0,
            character: true,
            speech: false,
            amount: 10,
            time: 2000
          },
          {
            type: "move",
            target: 1,
            toX: 150,
            toY: 70,
            time: 1000,
            speechAlsoMoves: false
          }
        ],
        12.0: [
          {
            type: "fade",
            target: 1,
            opacity: 0,
            time: 1000,
            speechAlsoFades: false
          }
        ]
      }
    });
  }
}

export default startWarpQuestCutscene