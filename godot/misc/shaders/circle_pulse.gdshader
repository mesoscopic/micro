shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"

void fragment() {
	float d = length(UV*2.-1.);
	float border = clamp(smoothstep(.6, .8, d+.1) - smoothstep(.6, .8, d-.1), 0., 1.);
	COLOR.a *= max(border, .6*step(.3, 1.-d));
}