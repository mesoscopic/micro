shader_type canvas_item;

#include "res://lygia/draw/stroke.gdshaderinc"
#include "res://lygia/draw/fill.gdshaderinc"

uniform float explode_anim: hint_range(0,1);

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(2.*xy.x) + abs(xy.y));
	d = mix(d, sqrt(pow(2.*xy.x, 2) + pow(xy.y, 2)), mix(0, -10, explode_anim));
	COLOR.a *= fill(d, 1.);
	COLOR.rgb *= stroke(d, 0.85, 0.3);
}