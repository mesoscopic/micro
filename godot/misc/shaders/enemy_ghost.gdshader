shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = length(xy);
	COLOR.a *= stroke(d, 0.9, 0.2);
}