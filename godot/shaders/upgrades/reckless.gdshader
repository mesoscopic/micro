shader_type canvas_item;

#include "../lygia/sdf/lineSDF.gdshaderinc"
#include "../lygia/sdf/circleSDF.gdshaderinc"
#include "../lygia/draw/stroke.gdshaderinc"

void fragment() {
	float circle = circleSDF(UV);
	float line1 = lineSDF(UV, vec2(0.5, 0.5), vec2(0.5+sin(TIME/4./PI)/4., 0.5+cos(TIME/4./PI)/4.));
	float line2 = lineSDF(UV, vec2(0.5, 0.5), vec2(0.5+cos(TIME/2.)/3., 0.5+sin(TIME/2.)/3.));
	float lines = min(line1, line2);
	COLOR.a *= clamp(stroke(circle, 0.9, 0.2) + stroke(lines, 0., 0.1), 0., 1.);
}