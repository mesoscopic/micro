shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"

instance uniform float health = 1.0;
instance uniform vec2 velocity = vec2(0.0);
instance uniform bool damaged = false;

void fragment() {
	float visual_health = health;
	if (damaged) {
		visual_health *= step(.1, mod(TIME, .2));
	}
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	vec2 xy_shifted = xy + velocity/10.;
	float d = length(xy);
	float d_shifted = length(xy_shifted);
	COLOR.a *= step(0., 1.-d);
	COLOR.rgb *= clamp(stroke(d, 0.9, 0.2) + fill(d_shifted, 0.5*visual_health), 0., 1.);
}