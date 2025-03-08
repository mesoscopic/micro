/*
contributors: Matt DesLauriers
description: Performs a smoothstep using standard derivatives for anti-aliased edges at any level of magnification. From https://github.com/glslify/glsl-aastep
use: aastep(<float> threshold, <float> value)
option:
    AA_EDGE: in the absence of derivatives you can specify the antialiasing factor
examples:
    - https://raw.githubusercontent.com/eduardfossas/lygia-study-examples/main/draw/aastep.frag
*/

#ifndef FNC_AASTEP
#define FNC_AASTEP

#if defined(GL_OES_standard_derivatives)
#extension GL_OES_standard_derivatives : enable
#endif

float aastep(float threshold, float value) {
	// godot will complain because the shader type isn't defined but this works when used in an actual shader
	float afwidth = 0.7 * length(vec2(dFdx(value), dFdy(value)));
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}
#endif