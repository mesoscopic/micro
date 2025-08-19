vec2 rotate(in vec2 uv, in float angle, in vec2 center) {
	float c = cos(angle);
	float s = sin(angle);
	mat2 rotation = mat2(vec2(c, s), vec2(-s, c));
	return rotation * (uv - center) + center;
}