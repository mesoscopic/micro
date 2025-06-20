shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D cracks;
uniform vec2 center = vec2(0.5);
uniform float progress: hint_range(0., 1.) = 0.;

void fragment() {
	COLOR.a = 0.;
	float value = texture(cracks, vec2(mod(UV.x+TIME/10., 1), mod(UV.y+TIME/10., 1))).r;
	vec2 p = UV - center;
	if(value > smoothstep(1., 1.-0.8*progress, 2.*max(abs(p.x),abs(p.y)))){
		// Invert screen pixel.
		vec4 pixel = texture(screen, UV);
		COLOR = vec4(vec3(1.) - pixel.rgb, 1.);
	}
}
