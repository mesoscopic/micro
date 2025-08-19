shader_type canvas_item;

#include "res://lib/shader/supershapesdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = superShapeSDF(UV, 2., 1., .15, 1., 0., 1., 8.);

	COLOR.a *= 1.- smoothstep(0.1, 0.3, d);
}