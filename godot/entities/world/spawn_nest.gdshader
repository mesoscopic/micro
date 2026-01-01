shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"

uniform float progress: hint_range(0.0, 1.0) = 0.;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(xy.x) + abs(xy.y));
	float s = 0.;
	for (int i = 0; i < 4; i++) {
		float ld = d/(mix(0., .1, progress)*float(i)+1.);
		float t = TIME+float(i)*.15;
		float p = sin(3.*t+sin(2.*t))*0.15*progress;
		s += .25*stroke(ld, mix(.9, .25, progress)+p*.5, mix(.2, .5, progress)+p);
	}
	COLOR.a *= s;
}