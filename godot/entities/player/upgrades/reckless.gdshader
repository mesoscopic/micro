shader_type canvas_item;

#include "res://lygia/sdf/lineSDF.gdshaderinc"
#include "res://lygia/sdf/circleSDF.gdshaderinc"
#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	float circle = circleSDF(UV);
	float line1 = lineSDF(UV, vec2(0.5, 0.5), vec2(0.716506, 0.375));
	float line2 = lineSDF(UV, vec2(0.5, 0.5), vec2(0.333333, 0.211325));
	float lines = min(line1, line2);
	float gray1 = lineSDF(UV, vec2(0.5, 0.5), vec2(0.676777, 0.323223));
	float gray2 = lineSDF(UV, vec2(0.5, 0.5), vec2(0.413726, 0.178025));
	float grays = min(gray1, gray2);
	COLOR.a *= clamp(stroke(circle, 0.9, 0.2)/1.5 + stroke(lines, 0., 0.1) + stroke(grays, 0.,0.1)/2., 0., 1.);
}