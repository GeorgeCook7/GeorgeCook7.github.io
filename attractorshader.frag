#version 460 core
#include <flutter/runtime_effect.glsl>
uniform vec2 uSize; // Inputs 0 and 1
uniform float zoom; // Input 2
uniform vec2 uPos; // Inputs 3 and 4
uniform vec4 objects[5]; //Input of undefinied length
out vec4 fragColor; // output colour for Flutter, like gl_FragColor
const int number_of_colours = 5;
vec2 iResolution;
float iTime;

vec4 getColor(int i,int iter){
    if (iter == 0){
        return vec4(50.0,50.0,50.0,1.0);
    }
    if (i == 0){
        return vec4(255,0,0,1);
    }
    else if (i == 1){
        return vec4(205,255,0,1);
    }
    else if (i == 2){
        return vec4(0,255,102,1);
    }
    else if (i == 3){
        return vec4(0,102,255,1);
    }
    else{
        return vec4(205,0,255,1);
    }
}

vec4 iterate(vec2 position){
    vec2 vel = vec2(0,0);
    for (int i=0; i < 100; i++ ){
        for (int k=0; k<5; k++){
            if (length(objects[k].yz-position) < objects[k].w){
                return getColor(k,i);
            }
        }
        for (int j=0; j<5; j++){
            if (objects[j].w == 0){
                break;
            }
            vel = vel + (objects[j].yz-position)*(objects[j].x/pow(length(objects[j].yz-position),2.0));
        }
        position = position + vel;  
    }
    return vec4(0.0,0.0,0.0,1.0);
}

void main()
{
    vec2 iResolution = uSize;
    vec2 fragCoord = FlutterFragCoord();
   
    // Normalized pixel coordinates (from 0 to 1)
    float res = min(iResolution.x, iResolution.y);
    vec2 pos = uPos+(2.0*((fragCoord-(iResolution/2.0))/res)/zoom); 
    fragColor = iterate(pos);
}