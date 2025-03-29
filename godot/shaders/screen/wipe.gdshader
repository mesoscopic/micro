shader_type canvas_item;

uniform float outer = 0.0;
uniform float inner = 0.0;

#include "../lygia/space/aspect.gdshaderinc"

void fragment() {
	vec2 xy = aspect((UV - vec2(0.5)) * 2.0, 1./SCREEN_PIXEL_SIZE);
	float d = (abs(xy.x) + abs(xy.y));
	if (d < inner || d > outer) {
		COLOR.a = 0.;
	}
}