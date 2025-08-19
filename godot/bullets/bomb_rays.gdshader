shader_type canvas_item;

instance uniform int rays = 8;

#include "res://lib/shader/sdfutil.gdshaderinc"

float raysSDF(in vec2 uv, in int ray_number) {
	uv -= 0.5;
	return fract(atan(uv.y,uv.x) / TAU * float(ray_number));
}

void fragment() {
	COLOR.a *= stroke(raysSDF(UV, rays), .5, 0.2) - 4.5*(pow(UV.x-.5, 2.)+pow(UV.y-.5, 2.));
}
