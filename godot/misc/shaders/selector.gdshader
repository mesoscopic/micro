shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/rectsdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

float crossSDF(in vec2 uv, in float s) {
    vec2 size = vec2(.25, s);
    return min(rectSDF(uv.xy, size.xy),
               rectSDF(uv.xy, size.yx));
}

void fragment() {
	float d = min(squareSDF(UV), crossSDF(UV, 1.25)*.5);
	COLOR.a *= stroke(d, .9, 0.2);
}