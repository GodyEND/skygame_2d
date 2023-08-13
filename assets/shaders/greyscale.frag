#version 460 core

#include "common/common.glsl"
#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform vec2 vOffset;
uniform sampler2D tex;

out vec4 oColor;

void main(){
    vec2 coord = FlutterFragCoord().xy - vOffset;
    vec2 uv=coord/uResolution;
    vec4 texCol = clampedTexture(texture(tex, uv), uv);
    oColor=vec4(vec3((texCol.r+texCol.g+texCol.b)/3.),texCol.a);
}
