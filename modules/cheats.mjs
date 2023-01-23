import doTutorial from './combattutorial.mjs'
import {version, compareVersions, checkVersion} from './version.mjs'

export default function openCheatMenu(world, funcs){
  
  if(!world.tags.includes('Cheated')) world.tags.push('Cheated');
  
  window.cheating = true;
  $('#cheats').attr('open', true);
  for(var i in world.player.inventory){
    $(`<option value="${i}">${i}</option>`).appendTo('#cheat_give_what');
  }
  $('#cheat_give_exec').click(()=>{
    var amount = $('#cheat_give_amount').val();
    var what = $('#cheat_give_what').val();
    if(parseInt(amount)){
      world.player.inventory[what].discovered = true;
      world.player.inventory[what].quantity += parseInt(amount);
      if(world.player.inventory[what].quantity < 0){
        world.player.inventory[what].quantity = 0;
      }
      funcs.render(world);
    }
  });
  $('#cheat_reset_wall').click(()=>{
    if(confirm('You are about to reset the wall quest. The wall will remain as it is a permanent map change, but your quest discovery, progress, and benefits will be wiped.')){
      world.world.discoveredEnemies = false;
      world.world.completedWallQuest = false;
      funcs.render(world);
    }
  });
  $('#cheat_reset_warp').click(()=>{
    if(confirm('You are about to reset the warp quest. The map changes will remain as they are permanent, but your quest discovery, progress, and benefits will be wiped.')){
      world.world.discoveredFragments = false;
      world.world.warpQuestStage = 0;
      funcs.render(world);
    }
  });
  $('#cheat_wander_spawn').click(()=>world.spawnWanderer());
  $('#cheat_wander_kill').click(()=>world.killWanderer());
  $('#cheat_tutorial').click(()=>{
    $('#cheats button').off('click');
    $('#cheat_give_what').html('');
    $('#cheat_give_amount').val('');
    $('#cheats').removeAttr('open');
    window.cheating = false;
    $('#tutorial_enemy, #tutorial_ehealth, #tutorial_edmg').attr('x', 220).attr('opacity', 1);
    $('#tutorial_loot').attr('x', 150).text('');
    doTutorial(world);
  });
  $('#cheat_wander_get').click(()=>{
    world.world.unemployedWorkers++;
    funcs.render(world);
  })
  $('#cheat_wander_del').click(()=>{
    world.world.unemployedWorkers--;
    if(world.world.unemployedWorkers<0) world.world.unemployedWorkers = 0;
    funcs.render(world);
  });
  $('#cheat_ver_sim').click(()=>{
    var testVersion = $('#cheat_ver_which').val();
    if(/[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?/g.test(testVersion)){
      checkVersion(testVersion);
      $('#cheats button').off('click');
      $('#cheat_give_what').html('');
      $('#cheat_give_amount').val('');
      $('#cheats').removeAttr('open');
      window.cheating = false;
    }
  });
  $('#cheat_close').on('click', ()=>{
    $('#cheats button').off('click');
    $('#cheat_give_what').html('');
    $('#cheat_give_amount').val('');
    $('#cheats').removeAttr('open');
    window.cheating = false;
  });
}