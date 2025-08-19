shader_type canvas_item;

#include "res://lib/shader/simplexnoise.gdshaderinc"

instance uniform vec2 angle = vec2(0.);

void fragment() {
	float noise = (simplex_noise(1.5*UV+(TIME*angle))+1.)/4.;
	vec2 p = (UV-.5);
	COLOR.a *= clamp(noise-sqrt(p.x*p.x+p.y*p.y),0.,1.);
}