shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture, filter_linear_mipmap;
uniform vec2 dir;

// Adapted from https://github.com/Experience-Monks/glsl-fast-gaussian-blur
// Licensed under the MIT license found at https://github.com/Experience-Monks/glsl-fast-gaussian-blur/blob/master/LICENSE.md
// Copyright (c) 2015 Jam3
vec4 blur5(sampler2D image, vec2 uv, vec2 pixel_size, vec2 direction) {
	vec4 color = vec4(0.0);
	vec2 off1 = vec2(1.3333333333333333) * direction;
	color += texture(image, uv) * 0.29411764705882354;
	color += texture(image, uv + (off1*pixel_size)) * 0.35294117647058826;
	color += texture(image, uv - (off1*pixel_size)) * 0.35294117647058826;
	return color;
}

void fragment() {
	COLOR *= blur5(screen, UV, SCREEN_PIXEL_SIZE, dir);
}