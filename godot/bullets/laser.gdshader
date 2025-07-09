shader_type canvas_item;

instance uniform float line_length = 400.;
instance uniform float appear: hint_range(0,1.2) = 0.;
instance uniform float activate: hint_range(0,1.2) = 0.;
instance uniform float disappear: hint_range(0,1.2) = 0.;

#include "res://lygia/math/aastep.gdshaderinc"

void fragment() {
	float x = line_length * UV.x;
	float y = abs(UV.y-0.5);
	float activation = smoothstep(activate-0.2,activate,UV.x)-4.*smoothstep(disappear-.2, disappear, UV.x)+4.;
	COLOR.a -= aastep(0.25*(2.-activation), abs(2.*y-(1.5*activation+0.8*(clamp(sin(-x/50.+TIME*8.), 0., 1.))*(1.-activation))*abs(x/5.-floor(x/5.+0.5))));
	COLOR.a *= aastep(1.-appear, 1.-UV.x);
	COLOR.a *= 1.-0.7*activation+0.7*(1.-pow(smoothstep(appear, appear-.2, UV.x),.25))-0.5*(1.-activation)*abs(sin(x/50.-TIME*12.))-smoothstep(.9, 1., UV.x);
	COLOR.a *= smoothstep(disappear-.2, disappear, UV.x);
}