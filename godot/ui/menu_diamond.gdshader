shader_type canvas_item;

uniform float outer = 0.0;
uniform float inner = 0.0;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(xy.x) + abs(xy.y));
	if (d < inner || d > outer) {
		COLOR.a = 0.;
	}
}