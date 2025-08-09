shader_type canvas_item;

#include "res://lygia/sdf/rhombSDF.gdshaderinc"
#include "res://lygia/draw/stroke.gdshaderinc"
#include "res://lygia/draw/fill.gdshaderinc"

void fragment() {
	float d = rhombSDF(UV);
	COLOR.a *= clamp(stroke(d, 1., 0.4) + stroke(d, 0.5, 0.3)/1.5 + fill(d, 0.2)/2., 0., 1.);
}