shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/simplexnoise.gdshaderinc"

instance uniform float form_anim: hint_range(0,1) = 0.;
instance uniform float dissolve_anim: hint_range(0,1) = 0.;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(2.*xy.x) + abs(xy.y));
	COLOR.a *= fill(d*form_anim, 1.);
	COLOR.rgb *= stroke(d, 0.85*form_anim, 1.-0.7*form_anim);

	// Dissolve animation
	COLOR.a *= aastep(-2.+dissolve_anim*3.+UV.y, simplex_noise(VERTEX/10.));
}