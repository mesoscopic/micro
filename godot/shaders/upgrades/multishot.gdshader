shader_type canvas_item;

#include "../lygia/sdf/lineSDF.gdshaderinc"
#include "../lygia/draw/stroke.gdshaderinc"

void fragment() {
	float d1 = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.5, 0.133975));
	float d2 = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.707107, 0.292893));
	float d3 = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.866025,0.5));
	float d = min(min(d1, d2), d3);
	COLOR.a *= stroke(d, 0., 0.1);
}