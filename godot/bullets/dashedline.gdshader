shader_type canvas_item;

uniform float speed = 20.;
uniform float fadeout = 0.25;
instance uniform float appear: hint_range(0, 1) = 0.;
instance uniform float disappear: hint_range(0, 1) = 0.;

#include "res://lygia/math/aastep.gdshaderinc"

void fragment() {
	float x = COLOR.a;
	COLOR.a = smoothstep(0., fadeout, x)/3.;
	COLOR.a *= aastep(0., sin(x*100.+TIME*speed));
	COLOR.a *= smoothstep(1.-appear, 1.-appear+(.5-abs(appear-.5)), x);
	COLOR.a *= 1.-smoothstep(1.-disappear, 1.-disappear+(.5-abs(disappear-.5)), x);
}