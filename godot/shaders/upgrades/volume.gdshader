shader_type canvas_item;

#include "../lygia/sdf/rhombSDF.gdshaderinc"
#include "../lygia/draw/stroke.gdshaderinc"

void fragment() {
	float d = rhombSDF(UV);
	COLOR.a *= clamp(stroke(d, 1., 0.4) + 0.5*stroke(d, 0.5, 0.3), 0., 1.);
}