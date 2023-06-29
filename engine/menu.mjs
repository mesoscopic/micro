export default {
    init: function(){
        $('#mainmenu-play').click(()=>{
            Micro.screens.switch('worldselect');
            Micro.screens.build('worlselect');
        })
        $('#mainmenu-settings').click(()=>{
            Micro.screens.switch('globalsettings');
            Micro.screens.build('globalsettings');
        })
    }
}