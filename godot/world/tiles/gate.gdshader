shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	vec2 lUV = 5.*mod(UV, 0.2);
	float d = squareSDF(lUV);
	COLOR.a *= 0.5*(stroke(d, 0.9, 0.2)+stroke(d,0.5,0.2));
}