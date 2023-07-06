export default {
    init: function(){
        $(document).keydown((e)=>{
            switch (e.key) {
                case 'Escape':
                    $('section#'+Micro.screens.active+' .escape').click();
            }
        })
    }
}