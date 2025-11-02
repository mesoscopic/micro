shader_type canvas_item;

#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/hexsdf.gdshaderinc"

void fragment() {
	COLOR.a = stroke(hexSDF(2.*(UV-.5)), .7, 0.2) + stroke(hexSDF(2.*(UV-.5)), .3, 0.2) * mix(.5,1.,COLOR.a);
}