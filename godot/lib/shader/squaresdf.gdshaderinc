float squareSDF(in vec2 uv) {
	return max(abs(uv.x * 2. - 1.), abs(uv.y * 2. - 1.));
}