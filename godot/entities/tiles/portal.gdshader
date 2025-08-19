shader_type canvas_item;

#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/rotate.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"

void fragment() {
	COLOR.a *= clamp(
		(1.+0.25*sin(4.*TIME))*stroke(squareSDF(rotate(UV, TIME, vec2(0.5))), 0.6, 0.15) +
		(1.+0.25*sin(4.*TIME+1.))*stroke(squareSDF(rotate(UV, PI/4. - 1.5*TIME, vec2(0.5))), 0.5, 0.15) +
		(1.+0.25*sin(4.*TIME+2.))*stroke(squareSDF(rotate(UV, -2.*TIME, vec2(0.5))), 0.4, 0.1) +
		(1.+0.25*sin(4.*TIME+3.))*stroke(squareSDF(rotate(UV, PI/4. + 2.5*TIME, vec2(0.5))), 0.3, 0.1)
	, 0., 1.);
}