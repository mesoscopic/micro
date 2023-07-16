export default {
    active: true,
    init: function(){
        $('#mainmenu-play').click(()=>{
            Micro.screens.switch('worldselect');
            Micro.screens.build('worldselect');
        })
        $('#mainmenu-settings').click(()=>{
            Micro.screens.switch('globalsettings');
            Micro.screens.build('globalsettings');
        })
        $('#worldselect .escape').click(()=>{
            Micro.screens.switch('mainmenu');
            Micro.screens.build('mainmenu');
        })
        $('#globalsettings .escape').click(()=>{
            Micro.screens.switch('mainmenu');
            Micro.screens.build('mainmenu');
        })
    }
}