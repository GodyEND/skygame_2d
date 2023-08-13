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
    oColor = clampedTexture(texture(tex, uv),uv);
}
