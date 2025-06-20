shader_type canvas_item;

#include "res://lygia/sdf/rectSDF.gdshaderinc"
#include "res://lygia/space/rotate.gdshaderinc"
#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	COLOR.a *= clamp(
		stroke(rectSDF(UV, 1.), 0.6, 0.15) +
		stroke(rectSDF(rotate(UV, PI/4., vec2(0.5)), 1.), 0.6, 0.15)
	, 0., 1.);
	COLOR.a *= .9+0.1*sin(TIME*3.);
}