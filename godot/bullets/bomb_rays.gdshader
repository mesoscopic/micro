shader_type canvas_item;

instance uniform int rays = 8;

#include "res://lygia/sdf/raysSDF.gdshaderinc"
#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	COLOR.a *= stroke(raysSDF(UV, rays), .5, 0.2) - 4.5*(pow(UV.x-.5, 2.)+pow(UV.y-.5, 2.));
}
