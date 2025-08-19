shader_type canvas_item;

uniform float outer = 0.0;
uniform float inner = 0.0;

vec2 correct_aspect(vec2 uv, vec2 ratio) {
	uv.x *= (ratio.x / ratio.y);
	return uv;
}

void fragment() {
	vec2 xy = correct_aspect((UV - vec2(0.5)) * 2.0, 1./SCREEN_PIXEL_SIZE);
	float d = (abs(xy.x) + abs(xy.y));
	if (d < inner || d > outer) {
		COLOR.a = 0.;
	}
}