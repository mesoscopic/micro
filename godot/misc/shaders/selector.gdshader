shader_type canvas_item;

#include "res://lygia/sdf/rectSDF.gdshaderinc"
#include "res://lygia/sdf/crossSDF.gdshaderinc"
#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = min(rectSDF(UV, 1.), crossSDF(UV, 1.25) * 0.5);

	COLOR.a *= stroke(d, .9, 0.2);
}