shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	vec2 xy = 2.*UV-1.;
	float d1 = abs(xy.x-.25) + abs(xy.y);
	float d2 = abs(xy.x+.25) + abs(xy.y);
	COLOR.a *= stroke(d1, 0.5, 0.2) + max(fill(d1, 0.25)/2., stroke(d2, 0.5, 0.2)/1.5);
}