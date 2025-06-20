shader_type canvas_item;

#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(xy.x) + abs(xy.y));
	COLOR.a *= stroke(d, 0.9, 0.2);
}