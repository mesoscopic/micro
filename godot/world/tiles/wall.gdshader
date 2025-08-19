shader_type canvas_item;
render_mode skip_vertex_transform;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

varying vec2 lVERTEX;

void vertex() {
	lVERTEX = VERTEX;
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 lUV = 5.*mod(UV, 0.2);
	float d = squareSDF(lUV);
	COLOR.a *= clamp(stroke(d, 0.9, 0.2) + (d<.9?aastep(sin(20.*(lUV.x+lUV.y)), -0.5):0.), 0., 1.);
}