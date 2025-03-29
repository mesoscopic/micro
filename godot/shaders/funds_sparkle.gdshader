shader_type canvas_item;

#include "lygia/sdf/superShapeSDF.gdshaderinc"
#include "lygia/draw/fill.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = superShapeSDF(UV, 2., 1., .15, 1., 0., 1., 8.);

	COLOR.a *= fill(d, 0.2, 0.1);
}