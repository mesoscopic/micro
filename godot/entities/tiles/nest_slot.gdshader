shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	float d = squareSDF(UV);

	COLOR.a *= stroke(d, 0.6, 0.2) * 0.5;
}