vec4 clampedTexture(vec4 texCol, vec2 uv) {
    if (uv.x > 1 || uv.x < 0 || uv.y > 1 || uv.y < 0) {
        return vec4(0);
    }
    return texCol;
}
