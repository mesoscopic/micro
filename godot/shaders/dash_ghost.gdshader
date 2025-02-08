shader_type canvas_item;

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * 2.0;
	float d = (abs(uv.x) + abs(uv.y));
	float c = 0.0;
	if ((d < 1.0 && d > 0.8)) {
		c = 1.0;
	}
	COLOR.a *= c;
}