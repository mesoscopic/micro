shader_type canvas_item;

#include "lygia/sdf/rectSDF.gdshaderinc"
#include "lygia/sdf/crossSDF.gdshaderinc"
#include "lygia/draw/stroke.gdshaderinc"
#include "lygia/draw/fill.gdshaderinc"

uniform vec2 velocity = vec2(0.0);

void fragment() {
	vec2 uv_shifted = UV + velocity/10.;
	float d = rectSDF(UV, 1.);
	float d_shifted = rectSDF(uv_shifted, .9);
	COLOR.rgb *= clamp(stroke(d, 0.9, 0.2) + fill(d_shifted, 0.6), 0., 1.);
}