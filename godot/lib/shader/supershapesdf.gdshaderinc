float superShapeSDF( in vec2 uv, in float s, in float a, in float b, in float n1, in float n2, in float n3, in float m ) {
    uv -= vec2(.5);
    vec2 polar = vec2(atan(uv.y, uv.x), length(uv));
    float d = polar.y * 5.0;
    float theta = polar.x;
    float t1 = abs((1.0/a) * cos(m * theta * 0.25));
    t1 = pow(t1, n2);
    float t2 = abs((1.0/b) * sin(m * theta * 0.25));
    t2 = pow(t2, n3);
    float t3 = t1 + t2;
    float r = pow(t3, -1.0 / n1);
    vec2 q = s * r * vec2(cos(theta), sin(theta));
    return d - length(q);
}