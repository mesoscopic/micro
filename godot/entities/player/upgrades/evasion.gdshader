shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/linesdf.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 3.0;
	xy.x -= 0.5;
	float circle = (abs(xy.x) + abs(xy.y));
	float line1 = lineSDF(UV, vec2(0.05, 0.3), vec2(0.3, 0.3));
	float line2 = lineSDF(UV, vec2(0.05, 0.7), vec2(0.4, 0.7));
	float line3 = lineSDF(UV, vec2(0.05, 0.5), vec2(0.2, 0.5));
	float lines = min(line1, min(line2, line3));
	COLOR.a *= clamp(stroke(circle, 0.8, 0.4) + fill(circle, 0.3)/2. + stroke(lines, 0., 0.1)/1.5, 0., 1.);
}