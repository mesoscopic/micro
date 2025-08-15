shader_type canvas_item;

instance uniform int rays = 8;

#include "res://lygia/sdf/superShapeSDF.gdshaderinc"
#include "res://lygia/draw/fill.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = superShapeSDF(UV, 2., 1., .4, 1., 0., 1., float(rays)*2.);

	COLOR.a *= fill(d, 0.2, 0.1);
}