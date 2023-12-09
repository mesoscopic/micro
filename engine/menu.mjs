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
        $('#createworld .escape').click(()=>{
            Micro.screens.switch('worldselect');
        })
        $('#globalsettings .escape').click(()=>{
            Micro.screens.switch('mainmenu');
        })
        $('#editworld .escape').click(()=>{
            Micro.screens.switch('worldselect');
        })
    }
}