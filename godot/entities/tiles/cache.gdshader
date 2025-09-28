shader_type canvas_item;

instance uniform float open_anim = 0.;
instance uniform float burn_anim = 0.;

uniform sampler2D noise;

#include "res://lib/shader/aa.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = length(xy);
	float n = aastep(mix(mix(0.8, 0.2, open_anim), 1., d+mix(0., 1., burn_anim)), texture(noise, UV).a);
	COLOR = vec4(vec3(n), clamp(1.-d*d+n, 0., 1.));
}