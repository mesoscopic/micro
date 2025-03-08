shader_type canvas_item;

#include "lygia/draw/fill.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = length(xy);

	COLOR.a *= fill(d, 1.);
}
