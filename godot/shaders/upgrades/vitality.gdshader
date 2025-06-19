shader_type canvas_item;

#include "../lygia/draw/fill.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(xy.x) + abs(xy.y));
	COLOR.a *= fill(d, 0.75+sin(3.*TIME+sin(2.*TIME))*0.15);
}