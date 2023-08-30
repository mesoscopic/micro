export default {
    active: null,
    //Switches the active screen. All <section>s are faded out, and a section with the 'to' id is faded in.
    switch: function(to, time){
        Micro.screens.active = to;
        return new Promise((res, rej)=>{
            if(time){
                $('section').fadeOut(time);
                $('#'+to).fadeIn(time, res);
            } else {
                $('section').hide();
                $('#'+to).show();
            }
            Micro.screens.build(to);
        });
	},
    //Sends a buildscreen event with the screen id passed.
    build: function(screen){
        Micro.modules.sendEvent('buildscreen', screen);
    }
}