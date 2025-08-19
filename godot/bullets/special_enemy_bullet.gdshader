shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/simplexnoise.gdshaderinc"

instance uniform float form_anim: hint_range(0,1) = 0.;
instance uniform float dissolve_anim: hint_range(0,1) = 0.;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(2.*xy.x) + abs(xy.y));
	COLOR.a *= fill(d, 1.0);
	COLOR.rgb -= vec3(stroke(d, 0.5, 0.3));

	// Form animation
	COLOR.a *= smoothstep(form_anim*-2.+1., form_anim*-4.+3., simplex_noise(VERTEX/30.));

	// Dissolve animation
	COLOR.a *= aastep(-2.+dissolve_anim*3.+UV.y, simplex_noise(VERTEX/10.));
}