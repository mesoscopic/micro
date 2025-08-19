shader_type canvas_item;

instance uniform float offset = 0.;
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	float t = TIME + offset;
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(xy.x) + abs(xy.y));
	COLOR.a *= fill(d, 0.75+sin(3.*t+sin(2.*t))*0.15);
}