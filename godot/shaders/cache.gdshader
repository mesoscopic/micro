shader_type canvas_item;

uniform float opacity = 1.0;
uniform float open_anim = 0.;
uniform float burn_anim = 0.;

uniform sampler2D noise;

#include "lygia/math/aastep.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = length(xy);
	COLOR.a *= mix(opacity, 1.0, open_anim);
	COLOR.a *= aastep(mix(mix(0.8, 0.2, open_anim), 1., d+mix(0., 1., burn_anim)), texture(noise, UV).a);
}