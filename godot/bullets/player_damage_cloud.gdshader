shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture, filter_linear_mipmap;
instance uniform float progress: hint_range(0., 1.) = 0.;

void fragment() {
	COLOR.a = 0.;
	vec2 p = UV - vec2(.5);
	float d = abs(p.x)+abs(p.y);
	vec4 pixel = textureLod(screen, SCREEN_UV, 0.8);
	COLOR = vec4(pow(pixel.r, .25), pow(pixel.g, .25), pow(pixel.b, .25), (1.-progress)*smoothstep(.5,.25,d));
}