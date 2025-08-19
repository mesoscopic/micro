float lineSDF( in vec2 uv, in vec2 a, in vec2 b ) {
    vec2 b_to_a = b - a;
    vec2 to_a = uv - a;
    float h = clamp(dot(to_a, b_to_a)/dot(b_to_a, b_to_a), 0., 1.);
    return length(to_a - h * b_to_a );
}