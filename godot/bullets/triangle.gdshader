shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/simplexnoise.gdshaderinc"

instance uniform float dissolve_anim: hint_range(0,1) = 0.;

void fragment() {
	COLOR.a *= fill(abs(UV.x-.5)+abs(1.-UV.y)/2., .5);
	
	// Dissolve animation
	COLOR.a *= aastep(-2.+dissolve_anim*3.+UV.y, simplex_noise(VERTEX/10.));
}