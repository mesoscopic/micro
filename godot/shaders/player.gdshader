shader_type canvas_item;

#include "lygia/draw/stroke.gdshaderinc"
#include "lygia/draw/fill.gdshaderinc"

uniform float health = 1.0;
uniform vec2 velocity = vec2(0.0);
uniform bool can_dash = true;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	vec2 xy_shifted = xy + velocity/10.;
	float d = (abs(xy.x) + abs(xy.y));
	float d_shifted = (abs(xy_shifted.x) + abs(xy_shifted.y));
	COLOR.a *= step(0., 1.-d);
	COLOR.rgb *= clamp(stroke(d, 0.9, 0.2) * (can_dash ? 1. : 0.75) + fill(d_shifted, 0.5*health), 0., 1.);
}