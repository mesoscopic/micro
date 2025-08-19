float triSDF(in vec2 uv) {
    uv -= 0.5;
    uv *= 5.0;
    return max(abs(uv.x) * .866025 + uv.y * .5, -uv.y * 0.5);
}