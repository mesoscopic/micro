shader_type canvas_item;

#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = length(xy);
	COLOR.rgb *= clamp(stroke(d, 0.9, 0.2) + stroke(d, 0.5, 0.2), 0., 1.);
	COLOR.a *= stroke(d, 0.7, 0.6);
}