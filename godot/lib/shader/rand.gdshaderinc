float random(in float x) {
	return fract(sin(x) * 43758.5453);
}

float random(in vec2 x) {
	return fract(sin(dot(x.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 random2(in vec2 x) {
	return fract(sin(vec2(dot(x,vec2(127.1,311.7)),dot(x,vec2(269.5,183.3))))*43758.5453);
}