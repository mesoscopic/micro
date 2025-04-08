shader_type canvas_item;

#include "lygia/sdf/rectSDF.gdshaderinc"
#include "lygia/draw/stroke.gdshaderinc"

uniform float opacity = 1.0;

void fragment() {
	COLOR.a *= opacity;
	float d = rectSDF(UV, 1.);
	COLOR.a *= clamp(stroke(d, 0.9, 0.2) + (d<.9?aastep(sin(20.*(UV.x+UV.y)), -0.5):0.), 0., 1.);
}