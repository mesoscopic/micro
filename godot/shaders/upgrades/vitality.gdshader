shader_type canvas_item;

uniform float opacity = 1.0;

#include "../lygia/draw/fill.gdshaderinc"

void fragment() {
	COLOR.a *= opacity;
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(xy.x) + abs(xy.y));
	COLOR.a *= fill(d, 0.75+sin(3.*TIME+sin(2.*TIME))*0.15);
}