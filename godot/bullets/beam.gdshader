shader_type canvas_item;

#include "res://lib/shader/aa.gdshaderinc"

instance uniform bool telegraph = true;

void fragment() {
	float y = 1.-abs((UV.y-.5)*2.);
	COLOR.a *= aastep(.9, y) + (telegraph?0.:(1.-pow(smoothstep(.9*sqrt(COLOR.a), 0., y), 0.4)));
}