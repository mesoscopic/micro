shader_type canvas_item;

#include "res://lygia/sdf/rectSDF.gdshaderinc"
#include "res://lygia/space/rotate.gdshaderinc"
#include "res://lygia/draw/stroke.gdshaderinc"

void fragment() {
	COLOR.a *= clamp(
		(1.+0.25*sin(4.*TIME))*stroke(rectSDF(rotate(UV, TIME, vec2(0.5)), 1.), 0.6, 0.15) +
		(1.+0.25*sin(4.*TIME+1.))*stroke(rectSDF(rotate(UV, PI/4. - 1.5*TIME, vec2(0.5)), 1.), 0.5, 0.15) +
		(1.+0.25*sin(4.*TIME+2.))*stroke(rectSDF(rotate(UV, -2.*TIME, vec2(0.5)), 1.), 0.4, 0.1) +
		(1.+0.25*sin(4.*TIME+3.))*stroke(rectSDF(rotate(UV, PI/4. + 2.5*TIME, vec2(0.5)), 1.), 0.3, 0.1)
	, 0., 1.);
}