export default {
    active: true,
    init: function(){
        $('#mainmenu-play').click(()=>{
            Micro.screens.switch('worldselect');
        })
        $('#mainmenu-settings').click(()=>{
            Micro.screens.switch('globalsettings');
        })
        $('#worldselect .escape').click(()=>{
            Micro.screens.switch('mainmenu');
        })
        $('#globalsettings .escape').click(()=>{
            Micro.screens.switch('mainmenu');
        })
    }
}