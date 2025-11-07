shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture;

void fragment() {
	vec3 c = vec3(0.);
	for(int i = 50; i > 0; i--) {
		c += texture(screen, SCREEN_UV-0.01*(SCREEN_UV-vec2(.5))*float(i)).rgb * .05;
	}
	COLOR.rgb = max(texture(screen, SCREEN_UV).rgb, clamp(c, vec3(0.), vec3(1.)));
	COLOR.a *= 1.-length(2.*UV-vec2(1.));
}
