shader_type canvas_item;

uniform float explode_anim: hint_range(0,1);

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * 2.0;
	float d = (abs(2.*uv.x) + abs(uv.y));
	if(explode_anim>0.){
		d = mix(d, sqrt(pow(2.*uv.x, 2) + pow(uv.y, 2)), mix(0, -10, explode_anim));
	}
	vec4 c = vec4(0.0);
	if (d < 1. && d > 0.5) {
		c = vec4(0.0, 0.0, 0.0, 1.0);
	}
	if (d < 0.9 && d > 0.6) {
		c = vec4(1.0);
	}
	COLOR = c;
}