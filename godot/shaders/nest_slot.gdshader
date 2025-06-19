shader_type canvas_item;

#include "lygia/sdf/rectSDF.gdshaderinc"
#include "lygia/draw/stroke.gdshaderinc"

void fragment() {
	float d = rectSDF(UV, 0.7);

	COLOR.a *= stroke(d, 0.9, 0.1*sin(4.0*TIME)+0.2);
}