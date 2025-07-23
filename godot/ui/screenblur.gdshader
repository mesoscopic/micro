shader_type canvas_item;

#define SAMPLER_FNC(TEX, UV) texture(TEX, UV)

uniform sampler2D screen: hint_screen_texture, filter_linear_mipmap;
#include "res://lygia/filter/gaussianBlur/2D.gdshaderinc"

void fragment() {
	COLOR.rgb = gaussianBlur2D(screen, UV, SCREEN_PIXEL_SIZE, 5).rgb * 0.4;
}