shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/smoothmin.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d1 = length(xy-vec2(.4));
	float d2 = length(xy+vec2(.4));
	COLOR.rgb = vec3(fill(smin(d1, d2, .1), 0.5));
	COLOR.a *= fill(smin(d1, d2, .05), 0.6);
}