shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/rotate.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	COLOR.a *= clamp(
		stroke(squareSDF(UV), 0.6, 0.15) +
		stroke(squareSDF(rotate(UV, PI/4., vec2(0.5))), 0.6, 0.15)
	, 0., 1.);
	COLOR.a *= .9+0.1*sin(TIME*3.);
}