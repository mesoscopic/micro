float aastep(float threshold, float value) {
	// godot will complain because the shader type isn't defined but this works when used in an actual shader
	float afwidth = 0.7 * length(vec2(dFdx(value), dFdy(value)));
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}