export default {
  animateAttr: function(e, a, v, d, c){
    var proxyDiv = $("<div></div>");
    proxyDiv.css("left", $(e).attr(a)+"px");
    proxyDiv.animate(
      {"left":v},
      {
        duration:d,
        step:function(s){
          $(e).attr(a,s+"");
        },
        complete:c
      }
    );
  },
  loot: function(table, rolls){
    var loot = [];
    var buckettotal = table.map((i)=>i.weight).reduce((p, c)=>p+c, 0);
    function roll(){
      var r = Math.floor(Math.random()*buckettotal + 1);
      var weight = 0;
      for(var i = 0; i < table.length; i++){
        weight += table[i].weight;
        if(r <= weight){
          if(table[i].item==null) continue;
          loot.push(table[i].item);
          break;
        }
      }
    }
    for(var i = 0; i < rolls; i++){
      roll();
    }
    return loot;
  },
  numberToCircles: function (num){
    if(num==0){return '○';}
    var circles = ''
    var fullCircles = Math.floor(num/4);
    var remainder = num-fullCircles*4;
    for(var i = 0; i<fullCircles; i++){
      circles+='●';
    }
    if(remainder<1){return circles;}
    else if(remainder<2){circles+='◔'; return circles;}
    else if(remainder<3){circles+='◑'; return circles;}
    else if(remainder<4){circles+='◕'; return circles;}
  },
  numberToTriangles: function(num){
    var triangles = '';
    for(var i = 0; i < num; i++){
      triangles += '►';
    }
    return triangles;
  },
  numberToCooldown: function(num){
    var squares = '';
    for(var i = 0; i < num; i++){
      squares += '▨';
    }
    return squares;
  },
  replaceTile: function(x, y, char, world){
    world.map[y] = this.stringReplaceAt(world.map[y], x, char);
		if(world.gameworld[y]){world.gameworld[y] = world.map[y]}
  },
  stringReplaceAt: function(str, index, replacement) {
    return str.substr(0, index) + replacement + str.substr(index + replacement.length);
  } 
}