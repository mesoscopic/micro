shader_type canvas_item;

uniform sampler2D cracks;
uniform float modulate: hint_range(0.,1.) = 0.;

void fragment() {
	if (COLOR.r > 0.1) {
		float value = texture(cracks, vec2(mod(SCREEN_UV.x, 1), mod(SCREEN_UV.y+TIME/10., 1))).r;
		COLOR = vec4(0., 0., 0., smoothstep(0., COLOR.r-0.1,value))*(1.-COLOR.r)*modulate;
	}
}