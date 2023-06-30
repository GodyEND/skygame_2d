#version 460 core

#include<flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform sampler2D tex;
uniform sampler2D aniTex;
uniform float thickness;
uniform vec4 borderCol;
uniform float angle;
uniform float isSelectable;

out vec4 oColor;

#define PI 3.1415926538

bool isOutOfBounds(vec2 cPos) {
    if (cPos.x < thickness || cPos.x > (uResolution.x - thickness)
     || cPos.y < thickness || cPos.y > (uResolution.y- thickness)) {
        return true;
    }
    return false;
}

bool validateBorder(vec2 cPos) {
    vec4 left=texture(tex,vec2(cPos.x-thickness, cPos.y)/uResolution);
    vec4 right=texture(tex,vec2(cPos.x+thickness, cPos.y)/uResolution);
    vec4 bottom=texture(tex,vec2(cPos.x, cPos.y-thickness)/uResolution);
    vec4 top=texture(tex,vec2(cPos.x, cPos.y+thickness)/uResolution);

    // TODO: diagonal checks
    return (left.a>0.||right.a>0.||top.a>0.||bottom.a>0.);
}



void main(){
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv=coord/uResolution;
    vec4 intensity = vec4(abs(sin(2*PI* mod(angle, PI/2) / (PI/2))));

    vec2 uvAniCenter = uv + vec2(-0.5);
    vec2 uvAni=vec2((uvAniCenter.x*cos(angle)-uvAniCenter.y*sin(angle))/2 + 0.5,
    (uvAniCenter.x*sin(angle)+uvAniCenter.y*cos(angle))/2 + 0.5);
    
    vec4 texCol=texture(tex,uv);
    if (isSelectable == 0.0) {
        texCol = vec4(vec3((texCol.r+texCol.g+texCol.b)/3.),texCol.a);
    }
    vec4 effCol=texture(aniTex, uvAni);
    vec4 blendedCol = (borderCol + texCol + effCol + intensity) / 4.0;
    if (texCol.a != 0.0 && isOutOfBounds(coord)) {
        oColor = blendedCol;
    } else {
        bool isBorder = texCol.a==0. && validateBorder(coord);
        oColor = isBorder ? blendedCol : texCol;
    }
}
