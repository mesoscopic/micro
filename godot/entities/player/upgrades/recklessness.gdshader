shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	vec2 uv = 2.*(UV - 0.5);
	float d1 = abs(uv.x-0.4) + abs(uv.y-0.4);
	float d2 = abs(uv.x) + abs(uv.y-0.565685);
	float d3 = abs(uv.x+0.4) + abs(uv.y-0.4);
	float c1 = length(uv + vec2(.4,.4));
	float c2 = length(uv + vec2(0.,.565685));
	float c3 = length(uv + vec2(-.4,.4));
	COLOR.a *= max(fill(min(d1, c1), 0.4), max(fill(min(d2, c2), 0.35)/1.5, fill(min(d3, c3), 0.3)/2.));
}