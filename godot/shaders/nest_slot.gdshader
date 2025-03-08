shader_type canvas_item;

#include "lygia/sdf/rectSDF.gdshaderinc"
#include "lygia/draw/stroke.gdshaderinc"

uniform float opacity = 1.0;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = rectSDF(UV, 0.7);
	float s = 0.025 * sin(4.0*TIME) + 0.025;

	COLOR.a *= opacity;
	COLOR.a *= stroke(d, 0.9, 0.1*sin(4.0*TIME)+0.2);
}