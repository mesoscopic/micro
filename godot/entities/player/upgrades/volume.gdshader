shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/trianglesdf.gdshaderinc"

void fragment() {
	float d = max(triSDF(UV), triSDF(vec2(UV.x, 1.-UV.y)));
	COLOR.a *= clamp(stroke(d, 1., 0.4) + stroke(d, 0.5, 0.3)/1.5 + fill(d, 0.2)/2., 0., 1.);
}