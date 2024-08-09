shader_type canvas_item;

uniform float health = 1.0;
uniform float opacity = 1.0;

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * 2.0;
	float d = (abs(uv.x) + abs(uv.y));
	float c = 0.0;
	if (d < (0.5*health) || (d < 1.0 && d > 0.8)) {
		c = 1.0;
	}
	COLOR = vec4(1.0, 1.0, 1.0, c*opacity);
}