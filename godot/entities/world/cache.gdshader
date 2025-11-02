shader_type canvas_item;

uniform sampler2D noise;

#include "res://lib/shader/aa.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = length(xy);
	float n = aastep(mix(mix(0.8, 0.2, COLOR.a), 1., d), texture(noise, UV).a);
	COLOR = vec4(vec3(n*mix(1.,0.3,COLOR.a)), clamp(1.-d*d+n, 0., 1.));
}