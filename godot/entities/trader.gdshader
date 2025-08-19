shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

instance uniform vec2 velocity = vec2(0.0);

void fragment() {
	vec2 uv_shifted = UV + velocity/10.;
	float d = squareSDF(UV);
	float d_shifted = squareSDF(uv_shifted);
	COLOR.rgb *= clamp(stroke(d, 0.9, 0.2) + fill(d_shifted, 0.55), 0., 1.);
}