shader_type canvas_item;

#include "res://lygia/draw/fill.gdshaderinc"
#include "res://lygia/math/aastep.gdshaderinc"
#include "res://lygia/generative/snoise.gdshaderinc"

instance uniform float form_anim: hint_range(0,1) = 0.;
instance uniform float dissolve_anim: hint_range(0,1) = 0.;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(2.*xy.x) + abs(xy.y));
	COLOR.a *= fill(d, 1.0);
	
	// Form animation
	COLOR.a *= smoothstep(form_anim*-2.+1., form_anim*-4.+3., snoise(VERTEX/30.));
	
	// Dissolve animation
	COLOR.a *= aastep(-2.+dissolve_anim*3.+UV.y, snoise(VERTEX/10.));
}