import util from './util.mjs'
import game from './game.mjs'

const menu = {
  TAGS: {
    "Cheated": "https://fonts.gstatic.com/s/i/short-term/release/materialsymbolsoutlined/terminal/default/48px.svg",
    "Imported": "https://fonts.gstatic.com/s/i/short-term/release/materialsymbolsoutlined/file_copy/default/48px.svg"
  },
  SETTINGS: [
    {
      id: "theme",
      name: "Theme:",
      kind: "radio",
      options: [
        {
          value: "light",
          name: "Light"
        },
        {
          value: "auto",
          name: "Auto"
        },
        {
          value: "dark",
          name: "Dark"
        }
      ],
      default: "auto",
      apply: (val)=>{
        if(val == 'light'){
          $(':root').css({
            "--bg": "#ffffff",
            "--fg": "#000000",
            "--ac": "blue",
            "--dark": "0"
          })
          $('#theme-override').attr('content', '#ffffff');
          $('#cutscene-overlay').removeClass('dark').removeClass('auto');
        }
        if(val == 'auto'){
          $(':root').css({
            "--bg": "",
            "--fg": "",
            "--ac": "",
            "--dark": ""
          });
          $('#theme-override').attr('content', '');
          $('#cutscene-overlay').removeClass('dark').addClass('auto');
        }
        if(val == 'dark'){
          $(':root').css({
            "--bg": "#121212",
            "--fg": "#ffffff",
            "--ac": "magenta",
            "--dark": "1"
          });
          $('#theme-override').attr('content', '#121212');
          $('#cutscene-overlay').addClass('dark').removeClass('auto');
        }
      }
    },
    {
      id: "music",
      name: "Music (awful placeholder):",
      kind: "toggle",
      default: true,
      apply: (val)=>{
        music.disabled = !val;
      }
    }
  ],
  
  build(){
    this.applySettings();
    window.menu = true; //This redirects all keyboard events to the menu
    this.show('init', true);
    let m = this;
    $('#playbutton').click(()=>{
      $('#save-select button').off('click');
      $('#save-select .backtoinit').one('click', ()=>{
        m.show('init');
      });
      var saves = JSON.parse(localStorage.getItem('micro__saves') || '[]');
      if(saves.filter((i)=>i.id=='betasave').length == 0 && localStorage.getItem('micro__betasave')){
        saves.push({
          "title": "Micro Beta Save",
          "id": "betasave",
          "time": Date.now()
        })
      }
      localStorage.setItem('micro__saves', JSON.stringify(saves));
      saves = saves.sort((i, o) => o.time - i.time);
      m.renderSaves(saves);
      m.show('save-select');
      $('#newsave').click(()=>{
        m.show('new-world');
        $('#new-world .backtoinit').one('click', ()=>{
          $('#new-world input').off('input');
          $('#new-world button').off('click');
          m.show('save-select');
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
            id: util.uuid(),
            time: Date.now()
          }
          s.push(newsave);
          localStorage.setItem('micro__saves', JSON.stringify(s));
          m.renderSaves(s);
          m.show('save-select');
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
              var decodedSave = JSON.parse(util.unibin.decode(save));
              if(!decodedSave.tags.includes('Imported')) decodedSave.tags.push('Imported');
              var id = util.uuid();
              var newsave = {
                title: file.name.split('.').slice(0, -1).join('.'),
                id: id,
                time: Date.now()
              }
              s.push(newsave);
              localStorage.setItem('micro__saves', JSON.stringify(s));
              localStorage.setItem('micro__'+id, JSON.stringify(decodedSave));
              m.renderSaves(s);
            });
          });
        }, ()=>{});
      });
    });
    $('#settingsbutton').click(()=>{
      m.renderSettings();
      $('#settings .backtoinit').one('click', ()=>{
        m.saveSettings();
        m.applySettings();
        m.show('init');
      });
      m.show('settings');
    });
  },
  show(id, anim){
    //Shows a menu screen, or hides the menu if 'game' is passed.
    if(anim){
      $('.screen').fadeOut(1000)
      if(id!='game') {
        $('#'+id).fadeIn(1000)
        $('#main-menu').fadeIn(1000)
      } else {
        $('#main-menu').fadeOut(1000)
      }
    } else {
      $('.screen').hide()
      if(id!='game') {
        $('#'+id).show()
        $('#main-menu').show()
      } else {
        $('#main-menu').hide()
      }
    }
  },
  renderSaves(saves){
    $('.save').remove();
    for(var i in saves){
      var save = $('<div class="save"></div>').appendTo('#save-select');
      var h2 = $('<h2></h2>').appendTo(save);
      $('<input type="text" is="editable-title">').val(saves[i].title).attr('size', (saves[i].title.length - 1)<1?1:(saves[i].title.length - 1)).appendTo(h2);
      var file = JSON.parse(localStorage.getItem('micro__'+saves[i].id));
      if(file) {
        var tags = file.tags;
        for(var j in tags){
          $('<img class="tag" src="'+this.TAGS[tags[j]]+'">').attr('title', tags[j]).appendTo(h2);
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
        let cs = e.selectionStart, ce = e.selectionEnd;
        var saveid = $($('.play')[i]).attr('data-save');
        var save = saves.filter((i)=>i.id==saveid)[0];
        save.title = $(e).val();
        localStorage.setItem('micro__saves', JSON.stringify(saves));
        this.renderSaves(saves);
        $('.save h2 input[type="text"]')[i].focus();
        $('.save h2 input[type="text"]')[i].setSelectionRange(cs,ce);
      });
    });
    $('.play').each((i, e)=>{
      $(e).click(()=>{
        var saveid = $(e).attr('data-save');
        saves.filter((i)=>i.id==saveid)[0].time = Date.now();
        localStorage.setItem('micro__saves', JSON.stringify(saves));
        window.menu = false;
        Micro.menu.show('game', true);
        $('.save').remove();
        game.start(saveid, ['../core/index.mjs']);
      });
    });
    $('.del').each((i, e)=>{
      $(e).click(()=>{
        var saveid = $(e).attr('data-save');
        if(!confirm('Are you sure? "'+saves.filter((i)=>i.id==saveid)[0].title+'" will be deleted forever!')) return;
        saves = saves.filter((i)=>i.id!=saveid);
        localStorage.setItem('micro__saves', JSON.stringify(saves));
        localStorage.removeItem('micro__'+saveid);
        this.renderSaves(saves);
      });
    });
    $('.export').each((i, e)=>{
      $(e).click(()=>{
        var saveid = $(e).attr('data-save');
        util.download(saves.filter((i)=>i.id==saveid)[0].title, util.unibin.encode(localStorage.getItem('micro__'+saveid)));
      });
    });
  },
  applySettings(){
    var settings = JSON.parse(localStorage.getItem('micro__betasets')||'{}');
    for(let i in this.SETTINGS){
      this.SETTINGS[i].apply(settings[this.SETTINGS[i].id]);
    }
  },
  saveSettings(){
    var settings = {};
    for(let i in this.SETTINGS){
      switch(this.SETTINGS[i].kind){
        case 'radio':
          settings[this.SETTINGS[i].id] = $('#setting-'+this.SETTINGS[i].id+' button.major').attr('value');
          break;
        case 'toggle':
          settings[this.SETTINGS[i].id] = $('#setting-'+this.SETTINGS[i].id+' button.major').attr('value') == 'on';
          break;
      }
    }
    localStorage.setItem('micro__betasets', JSON.stringify(settings));
  },
  renderSettings(){
    var settings = JSON.parse(localStorage.getItem('micro__betasets')||'{}');
    $('.setting').remove();
    for(let i in this.SETTINGS){
      switch(this.SETTINGS[i].kind){
        case 'radio':
          let e = $('<p class="setting radio" id="setting-'+this.SETTINGS[i].id+'">'+this.SETTINGS[i].name+'</p>')
          for(let j in this.SETTINGS[i].options){
            let b = $('<button value="'+this.SETTINGS[i].options[j].value+'">'+this.SETTINGS[i].options[j].name+'</button>');
            b.click(()=>{
              $('#setting-'+this.SETTINGS[i].id+' button').removeClass('major');
              b.addClass('major')
            });
            if((settings[this.SETTINGS[i].id] ?? this.SETTINGS[i].default) == this.SETTINGS[i].options[j].value){
              b.addClass('major');
            }
            b.appendTo(e);
          }
          e.appendTo('#settings');
          break;
        case 'toggle':
          let t = $('<p class="setting toggle" id="setting-'+this.SETTINGS[i].id+'">'+this.SETTINGS[i].name+'</p>')
          let o = $('<button value="on">On</button>');
          o.click(()=>{
            $('#setting-'+this.SETTINGS[i].id+' button').removeClass('major');
            o.addClass('major')
          });
          o.appendTo(t);
          let f = $('<button value="off">Off</button>');
          f.click(()=>{
            $('#setting-'+this.SETTINGS[i].id+' button').removeClass('major');
            f.addClass('major')
          });
          f.appendTo(t);
          ((settings[this.SETTINGS[i].id]??this.SETTINGS[i].default)?o:f).addClass('major');
          t.appendTo('#settings');
          break;
      }
    }
  }
}

export default menu;