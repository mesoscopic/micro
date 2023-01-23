import music from './music.mjs'

export default function menu(){
  return new Promise((res, rej)=>{
    window.menu = true;
    applySettings();
    $('#loading').hide();
    $('#main-menu').fadeIn(1000);
    $('#init').show();
    $('#save-select').hide();
    $('#playbutton').click(()=>{
      $('#init').hide();
      $('#save-select button').off('click');
      $('#save-select .backtoinit').one('click', ()=>{
        $('#save-select').hide();
        $('#init').show();
      });
      var saves = JSON.parse(localStorage.getItem('micro__saves') || '[]');
      if(saves.filter((i)=>i.id=='gamesave').length == 0 && localStorage.getItem('micro__gamesave')){
        saves.push({
          "title": "Micro Save",
          "id": "gamesave",
          "time": Date.now()
        })
      }
      localStorage.setItem('micro__saves', JSON.stringify(saves));
      saves = saves.sort((i, o) => o.time - i.time);
      renderSaves(saves, res);
      $('#newsave').click(()=>{
        $('#save-select').hide();
        $('#new-world').show();
        $('#new-world .backtoinit').one('click', ()=>{
          $('#new-world input').off('input');
          $('#new-world button').off('click');
          $('#new-world').hide();
          $('#save-select').show();
        });
        var name = $('#new-world input');
        name.attr('size', (name.val().length - 1)<1?1:(name.val().length - 1));
        name.on('input', ()=>{
          name.attr('size', (name.val().length - 1)<1?1:(name.val().length - 1))
        });
        $('#make-new').one('click', ()=>{
          var s = JSON.parse(localStorage.getItem('micro__saves'));
          var newsave = {
            title: name.val(),
            id: uuid(),
            time: Date.now()
          }
          s.push(newsave);
          localStorage.setItem('micro__saves', JSON.stringify(s));
          $('#new-world').hide();
          renderSaves(s, res);
        });
      });
      $('#importsave').click(()=>{
        window.showOpenFilePicker({
          types: [
            {
              description: "Micro Save File",
              accept: {
                "text/plain": ".microsave"
              }
            }
          ],
          multiple: false,
          excludeAcceptAllOption: true
        }).then((files)=>{
          files[0].getFile().then((file)=>{
            file.text().then((save)=>{
              var s = JSON.parse(localStorage.getItem('micro__saves'));
              var decodedSave = JSON.parse(fromBinary(save));
              if(!decodedSave.tags.includes('Imported')) decodedSave.tags.push('Imported');
              var id = uuid();
              var newsave = {
                title: file.name.split('.').slice(0, -1).join('.'),
                id: id,
                time: Date.now()
              }
              s.push(newsave);
              localStorage.setItem('micro__saves', JSON.stringify(s));
              localStorage.setItem('micro__'+id, JSON.stringify(decodedSave));
              renderSaves(s, res);
            });
          });
        }, ()=>{});
      });
    });
    $('#settingsbutton').click(()=>{
      renderSettings();
      $('#init').hide();
      $('#settings .backtoinit').one('click', ()=>{
        $('#settings').hide();
        saveSettings();
        applySettings();
        $('#init').show();
      });
      $('#settings').show();
    });
  });
}

function renderSaves(saves, res){
  const tagSymbols = {
    "Cheated": "terminal",
    "Imported": "file_copy"
  }
  
  $('.save').remove();
  for(var i in saves){
    var save = $('<div class="save"></div>').appendTo('#save-select');
    var h2 = $('<h2></h2>').appendTo(save);
    $('<input type="text">').val(saves[i].title).attr('size', (saves[i].title.length - 1)<1?1:(saves[i].title.length - 1)).appendTo(h2);
    var file = JSON.parse(localStorage.getItem('micro__'+saves[i].id));
    if(file) {
      var tags = file.tags;
      for(var j in tags){
        $('<span class="tag"></span>').attr('title', tags[j]).text(tagSymbols[tags[j]]).appendTo(h2);
      }
    }
    var p = $('<p></p>').text(saves[i].time?'Last opened '+new Date(saves[i].time).toDateString():'');
    p.appendTo(save);
    $('<button class="play major">Play</button>').attr('data-save', saves[i].id).appendTo(p);
    $('<button class="del">Delete</button>').attr('data-save', saves[i].id).appendTo(p);
    $('<button class="export">Export</button>').attr('data-save', saves[i].id).appendTo(p);
  }
  $('.save h2 input[type="text"]').each((i, e)=>{
    $(e).on('input', ()=>{
      var saveid = $($('.play')[i]).attr('data-save');
      var save = saves.filter((i)=>i.id==saveid)[0];
      save.title = $(e).val();
      localStorage.setItem('micro__saves', JSON.stringify(saves));
      renderSaves(saves, res);
      $('.save h2 input[type="text"]')[i].focus();
    });
  });
  $('.play').each((i, e)=>{
    $(e).click(()=>{
      var saveid = $(e).attr('data-save');
      saves.filter((i)=>i.id==saveid)[0].time = Date.now();
      localStorage.setItem('micro__saves', JSON.stringify(saves));
      $('#main-menu').fadeOut(1000);
      window.menu = false;
      $('.save').remove();
      res(saveid);
    });
  });
  $('.del').each((i, e)=>{
    $(e).click(()=>{
      var saveid = $(e).attr('data-save');
      if(!confirm('Are you sure? "'+saves.filter((i)=>i.id==saveid)[0].title+'" will be deleted forever!')) return;
      saves = saves.filter((i)=>i.id!=saveid);
      localStorage.setItem('micro__saves', JSON.stringify(saves));
      localStorage.removeItem('micro__'+saveid);
      renderSaves(saves, res);
    });
  });
  $('.export').each((i, e)=>{
    $(e).click(()=>{
      var saveid = $(e).attr('data-save');
      download(saves.filter((i)=>i.id==saveid)[0].title, toBinary(localStorage.getItem('micro__'+saveid)));
    });
  });
  $('#save-select').show();
}

function applySettings(){
  var settings = JSON.parse(localStorage.getItem('micro__sets')||'{}');
  
  //Theme
  if(settings.theme == 'light'){
    $(':root').css({
      "--bg": "#ffffff",
      "--fg": "#000000",
      "--ac": "blue"
    })
    $('#theme-override').attr('content', '#ffffff');
    $('#cutscene-overlay').removeClass('dark').removeClass('auto');
  }
  if(settings.theme == 'auto'){
    $(':root').css({
      "--bg": "",
      "--fg": "",
      "--ac": ""
    });
    $('#theme-override').attr('content', '');
    $('#cutscene-overlay').removeClass('dark').addClass('auto');
  }
  if(settings.theme == 'dark'){
    $(':root').css({
      "--bg": "#121212",
      "--fg": "#ffffff",
      "--ac": "magenta"
    });
    $('#theme-override').attr('content', '#121212');
    $('#cutscene-overlay').addClass('dark').removeClass('auto');
  }
  
  //Music
  music.disabled = !settings.music;
}

function saveSettings(){
  var settings = {};
  
  //Theme
  settings.theme = $('#setting-theme button.major').attr('value');
  
  //Music
  settings.music = $('#setting-music button.major').attr('value')=="on"
  
  localStorage.setItem('micro__sets', JSON.stringify(settings));
}

function renderSettings(){
  var settings = JSON.parse(localStorage.getItem('micro__sets')||'{}');
  
  //Theme
  $('#setting-theme button').removeClass('major');
  $('#setting-theme button[value='+(settings.theme||'auto')+']').addClass('major');
  $('#setting-theme button').each((i, e)=>{
    $(e).click(()=>{
      $('#setting-theme button').removeClass('major');
      $(e).addClass('major');
    })
  });
  
  //Music
  $('#setting-music button').removeClass('major');
  $('#setting-music button[value='+(settings.music?'on':'off')+']').addClass('major');
  $('#setting-music button').each((i, e)=>{
    $(e).click(()=>{
      $('#setting-music button').removeClass('major');
      $(e).addClass('major');
    })
  })
}

function download(name, data){
  debugger;
  var file = new File([data], name+'.microsave', {
    type: "text/plain"
  });
  var url = URL.createObjectURL(file);
  var a = $(`<a href="${url}" download="${file.name}"></a>`).appendTo('body')[0]
  a.click();
  $(a).remove();
  URL.revokeObjectURL(url);
}
function processUpload(file){
  
}

//Stack Overflow genius section
function uuid(){
  return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
    (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
  );
}
function toBinary(string) {
  const codeUnits = new Uint16Array(string.length);
  for (let i = 0; i < codeUnits.length; i++) {
    codeUnits[i] = string.charCodeAt(i);
  }
  return btoa(String.fromCharCode(...new Uint8Array(codeUnits.buffer)));
}
function fromBinary(encoded) {
  const binary = atob(encoded);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < bytes.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }
  return String.fromCharCode(...new Uint16Array(bytes.buffer));
}
