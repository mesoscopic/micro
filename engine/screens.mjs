export default {
    switch: function(to, time){
        return new Promise((res, rej)=>{
            if(time){
                $('section').fadeOut(time);
                $('#'+to).fadeIn(time, res);
                return;
            }
            $('main').hide();
            $('#'+to).show();
        });
	}
}