#version 460 core

#include<flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform sampler2D tex;
out vec4 oColor;

void main(){
    vec2 uv=vec2(FlutterFragCoord().xy)/uResolution;
    vec4 texCol=texture(tex,uv);
    oColor=vec4(vec3((texCol.r+texCol.g+texCol.b)/3.),texCol.a);
}
