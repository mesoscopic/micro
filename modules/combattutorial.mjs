import music from './music.mjs'
import util from './commonfunctions.mjs'
import render from './render.mjs'

export default function doTutorial(world){
  music.soundtracks.fight.start();
  $('#current-cutscene').html('<use href="#combattutorial">');
  $('#cutscene-overlay').show();
  world.cutscene = true;
  world.cutsceneControls = (control)=>{
    if(control==5){
      if(!canAttack){return;}
      canAttack = false;
      $('#tutorial_player').trigger('attack');
			util.animateAttr($("#tutorial_player"), "x", 150, 500, function(){
				util.animateAttr($("#tutorial_player"), "x", 50, 500, function(){
          canAttack = true;
          $('#tutorial_player').trigger('attackend');
					if(enemyHealth == 0){
            canAttack = false;
            canDodge = false;
            util.animateAttr($("#tutorial_enemy_corpse"), "opacity", 1, 500);
            util.animateAttr($("#tutorial_enemy"), "opacity", 0, 500, function(){
              var loot = ['▴']
              $("#tutorial_loot").text(loot.join(""));
              world.player.inventory['▴'].discovered = true;
              world.player.inventory['▴'].quantity++;
              world.world.didTutorial = true;
              render(world);
              util.animateAttr($("#tutorial_loot"), "x", 50, 500, ()=>{world.cutscene = false;$('#cutscene-overlay').hide();});
            });
          }
				});
        if($('#tutorial_enemy').attr('x') >= 125 && !isDodging){
          enemyHealth = (enemyHealth-playerDmg)<0 ? 0 : (enemyHealth-playerDmg);
          rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
          if(enemyHealth == 0){
            clearInterval(enemyAttack);
            window.music.soundtracks.safe.start();
            return;
          }
        }
			});
		} else if(control==7){
      if(!canDodge){return;}
      canDodge = false;
      $('#tutorial_player').trigger('dodge');
      isDodging=true;
      util.animateAttr($("#tutorial_player"), "y", 60, 250, function(){
				util.animateAttr($("#tutorial_player"), "y", 75, 250, function(){
          isDodging = false;
          var dodgeCooldown = playerDodgeSpeed;
          $('#tutorial_dodge').text(util.numberToCooldown(dodgeCooldown/100));
          dci = setInterval(()=>{dodgeCooldown-=100; $('#tutorial_dodge').text(util.numberToCooldown(dodgeCooldown/100)); if(dodgeCooldown==0){clearInterval(dci); canDodge = true; $('#tutorial_player').trigger('dodgeend');rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);}}, 100);
				});
			});
    }
  }
  
  var playerHealth = 10;
	var playerDmg = 1;
  var playerDodgeSpeed = 1000;
	var enemyHealth = 4;
	var enemyDmg = 1;
  var enemySpeed = 1500;
  var canAttack = false;
  var canDodge = false;
  var isDodging = false;
  var hci, dci;
  var enemyAttack;
  
  rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
  util.animateAttr($("#tutorial_enemy"), "x", 150, 500);
	util.animateAttr($("#tutorial_ehealth"), "x", 150, 500);
	util.animateAttr($("#tutorial_edmg"), "x", 150, 500, ()=>{
    util.animateAttr($('#tutorial_enemy'), 'x', 50, 500, ()=>{
      fadeOut();
      highlight('tedmghl', 1000, ()=>{
        playerHealth--;
        rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
        highlight('tphlhl', 1000, ()=>{
          fadeIn();
          util.animateAttr($('#tutorial_enemy'), 'x', 150, 500, ()=>{
            fadeOut();
            highlight('tpatkhl', 1000, ()=>{
              fadeIn();
              canAttack = true;
              $('#tutorial_player').one('attack', ()=>{
                util.animateAttr($('#tutorial_enemy'), 'x', 50, 500, ()=>{
                  util.animateAttr($('#tutorial_enemy'), 'x', 150, 500);
                });
              });
              $('#tutorial_player').one('attackend', ()=>{
                canAttack = false;
                util.animateAttr($('#tutorial_enemy'), 'x', 100, 250, ()=>{
                  fadeOut();
                  highlight('tpdghl', 1000, ()=>{
                    canDodge = true;
                    $('#tutorial_player').one('dodge', ()=>{
                      fadeIn();
                      util.animateAttr($('#tutorial_enemy'), 'x', 50, 250, ()=>{
                        util.animateAttr($('#tutorial_enemy'), 'x', 150, 500);
                      });
                    });
                    $('#tutorial_player').one('dodgeend', ()=>{
                      fadeOut();
                      highlight('tpatkhl', 1000, ()=>{
                        fadeIn();
                        canAttack = true;
                        $('#tutorial_player').one('attackend', ()=>{
                          enemyAttack = setInterval(function(){
                            util.animateAttr($("#tutorial_enemy"), "x", 50, ((enemySpeed-500)==0?500:(enemySpeed-500))/2, function(){
                              util.animateAttr($("#tutorial_enemy"), "x", 150, ((enemySpeed-500)==0?500:(enemySpeed-500))/2, function(){
                                if(playerHealth == 0){
                                  playerHealth = 1;
                                  rerender(playerHealth, playerDmg, enemyHealth, enemyDmg, world);
                                }
                              });
                              if($('#tutorial_player').attr('x') <= 75 && !isDodging){
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
                        })
                      });
                    })
                  });
                })
              })
            });
          });
        })
      });
    })
  });
}

function rerender(ph, pd, eh, ed, world){
	$("#tutorial_health").text(util.numberToCircles(ph));
	$("#tutorial_ehealth").text(util.numberToCircles(eh));
	$("#tutorial_damage").text('0: '+util.numberToTriangles(pd));
	$("#tutorial_edmg").text(util.numberToTriangles(ed));
  if(!$('#tutorial_dodge').text().includes('▨')) $("#tutorial_dodge").text('2: ◮');
}

function fadeOut(){
  util.animateAttr($('#tutorial_player'), 'opacity', 0.5, 500);
  util.animateAttr($('#tutorial_enemy'), 'opacity', 0.5, 500);
}

function fadeIn(){
  util.animateAttr($('#tutorial_player'), 'opacity', 1, 500);
  util.animateAttr($('#tutorial_enemy'), 'opacity', 1, 500);
}

function highlight(thing, time, c){
  util.animateAttr($('#'+thing), 'opacity', 1, 250);
  setTimeout(()=>{
    util.animateAttr($('#'+thing), 'opacity', 0, 250);
    c();
  }, time);
}