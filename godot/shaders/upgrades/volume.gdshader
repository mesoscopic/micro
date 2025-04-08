shader_type canvas_item;

uniform float opacity = 1.0;

#include "../lygia/sdf/rhombSDF.gdshaderinc"
#include "../lygia/draw/stroke.gdshaderinc"

void fragment() {
	COLOR.a *= opacity;
	float d = rhombSDF(UV);
	COLOR.a *= clamp(stroke(d, 1., 0.4) + 0.5*stroke(d, 0.5, 0.3), 0., 1.);
}