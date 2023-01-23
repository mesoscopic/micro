import util from './commonfunctions.mjs'
import startDialogue from './dialogue.mjs'
import render from './render.mjs'

export default function warp(toX, toY, world) {
  $('#current-cutscene').html('<use href="#warp">');
  $('#cutscene-overlay').show();
  world.cutscene = true;
  startDialogue({
    length: 8.0,
    finish: function(){
      world.cutscene = false;
      $('#cutscene-overlay').hide();
      world.player.pos = [toX, toY];
      render(world);
    },
    characters: [
      { //The player
        elem: $('#warp_player')
      },
      { //The first shard
        elem: $('#warp_shard1')
      },
      { //The second shard
        elem: $('#warp_shard2')
      },
      { //The third shard
        elem: $('#warp_shard3')
      },
      { //The fourth shard
        elem: $('#warp_shard4')
      },
      { //The portal
        elem: $('#warp_pad')
      }
    ],
    timeline: {
      0.0: [
        {
          type: "move",
          target: 0,
          toX: 50,
          toY: 50,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      1.0: [
        {
          type: "fade",
          target: 1,
          opacity: 1,
          time: 1000,
          speechAlsoFades: false
        },
        {
          type: "move",
          target: 1,
          toX: 150,
          toY: 75,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      2.0: [
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
      3.0: [
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
      4.0: [
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
      5.0: [
        {
          type: "fade",
          target: 1,
          opacity: 0,
          time: 0,
          speechAlsoFades: false
        },
        {
          type: "move",
          target: 1,
          toX: 50,
          toY: 50,
          time: 0,
          speechAlsoMoves: false
        },
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
          type: "shake",
          target: 5,
          character: true,
          speech: false,
          amount: 10,
          time: 2000
        },
        {
          type: "move",
          target: 0,
          toX: 150,
          toY: 70,
          time: 1000,
          speechAlsoMoves: false
        }
      ],
      6.0: [
        {
          type: "fade",
          target: 0,
          opacity: 0,
          time: 1000,
          speechAlsoFades: false
        }
      ],
      8.0: [
        {
          type: "fade",
          target: 0,
          opacity: 1,
          time: 0,
          speechAlsoFades: false
        }
      ]
    }
  });
}