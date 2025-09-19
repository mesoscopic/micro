shader_type canvas_item;

#include "res://lib/shader/hexsdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	COLOR.a *= stroke(hexSDF(xy), 0.7, 0.2);
}