float rectSDF(in vec2 uv, in vec2 size) {
	return max(abs(uv.x/size.x * 2. - 1.), abs(uv.y/size.y * 2. - 1.));
}