export default {
    active: null,
    switch: function(to, time){
        Micro.screens.active = to;
        return new Promise((res, rej)=>{
            if(time){
                $('section').fadeOut(time);
                $('#'+to).fadeIn(time, res);
                return;
            }
            $('section').hide();
            $('#'+to).show();
        });
	},
    build: function(screen){
        Micro.modules.sendEvent('buildscreen', screen);
    }
}