shader_type canvas_item;

#include "res://lygia/draw/fill.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d1 = (abs(xy.x-0.25) + abs(xy.y-0.25));
	float d2 = (abs(xy.x+0.5) + abs(xy.y+0.3));
	float d3 = (abs(xy.x-0.6) + abs(xy.y+0.5));
	COLOR.a *= clamp(fill(d1, 0.6)+fill(d2, 0.4)/1.5+fill(d3, 0.2)/2., 0., 1.);
}