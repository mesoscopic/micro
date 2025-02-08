shader_type canvas_item;

uniform float health = 1.0;
uniform float opacity = 1.0;
uniform vec2 velocity = vec2(0.0);
uniform bool can_dash = true;

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * 2.0;
	vec2 uv_shifted = uv + velocity/10.;
	float d = (abs(uv.x) + abs(uv.y));
	float d_shifted = (abs(uv_shifted.x) + abs(uv_shifted.y));
	float c = 0.0;
	if (d_shifted < (0.5*health)) {
		c = 1.0;
	}
	if (d < 1.0 && d > 0.8) {
		c = can_dash?1.0:0.75;
	}
	COLOR = vec4(1.0, 1.0, 1.0, c*opacity);
}