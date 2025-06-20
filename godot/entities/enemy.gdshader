shader_type canvas_item;

#include "res://lygia/draw/stroke.gdshaderinc"
#include "res://lygia/draw/fill.gdshaderinc"

uniform float health = 1.0;
uniform vec2 velocity = vec2(0.0);

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	vec2 xy_shifted = xy + velocity/10.;
	float d = length(xy);
	float d_shifted = length(xy_shifted);
	COLOR.a *= step(0., 1.-d);
	COLOR.rgb *= clamp(stroke(d, 0.9, 0.2) + fill(d_shifted, 0.5*health), 0., 1.);
}