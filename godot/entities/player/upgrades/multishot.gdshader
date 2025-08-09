shader_type canvas_item;

#include "res://lygia/sdf/lineSDF.gdshaderinc"
#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	float w = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.707107, 0.292893));
	float l1 = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.5, 0.133975));
	float l2 = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.866025,0.5));
	float l = min(l1, l2);
	float d1 = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.772741,0.792945));
	float d2 = lineSDF(UV, vec2(0.133975,0.866025), vec2(0.207055,0.227259));
	float d = min(d1, d2);
	COLOR.a *= max(max(stroke(w, 0., 0.1),stroke(l, 0., 0.1)/1.5),stroke(d, 0., 0.1)/2.);
}