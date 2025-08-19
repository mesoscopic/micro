shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR *= textureLod(screen, UV, 0.8);
}