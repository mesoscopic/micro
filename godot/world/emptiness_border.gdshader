shader_type canvas_item;

uniform sampler2D noise;

void fragment() {
	COLOR = texture(noise, vec2(mod(COLOR.r+TIME/20., 1.), 0.)) * pow(sin(COLOR.r*PI), 2.);
}