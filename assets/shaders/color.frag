#version 460 core

#include<flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform sampler2D tex;

out vec4 oColor;


void main(){
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv=coord/uResolution;
    vec4 texCol=texture(tex,uv);
    oColor = texCol;
}
