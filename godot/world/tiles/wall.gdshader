shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	vec2 lUV = 5.*mod(UV, 0.2);
	float d = squareSDF(lUV);
	COLOR.a *= clamp(stroke(d, 0.9, 0.2) + (d<.9?aastep(0.25, sin(20.*(lUV.x+lUV.y))):0.), 0., 1.);
}