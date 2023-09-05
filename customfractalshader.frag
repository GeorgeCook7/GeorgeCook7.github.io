#version 460 core
#include <flutter/runtime_effect.glsl>
uniform vec2 uSize; // Inputs 0 and 1
uniform float zoom; // Input 2
uniform vec2 uPos; // Inputs 3 and 4
uniform float brotOrJulia; // Input 5
uniform vec2 mousePos; // Inputs 6 and 7 
uniform vec3 exprX[4]; //Input of undefinied length
uniform vec3 exprY[4]; //Input of undefinied length
out vec4 fragColor; // output colour for Flutter, like gl_FragColor
const int Iterations = 100;
const int number_of_colours = 9;
vec2 iResolution;

float power(float base, float exponent){
    int ex = int(exponent);
    switch(ex){
        case 0:
            return 1.0;
        case 1:
            return base;
        case 2:
            return base*base;
        case 3:
            return base*base*base;
    }
    return 1.0;
}

float interpret(vec3 expression[4], vec2 number){
    float total = 0.0;
    for (int i=0; i<4; i++){
        if (expression[i].x == 0.0){
            break;
        }
        else{
            total += expression[i].x*power(number.x,expression[i].y)*power(number.y,expression[i].z);
        }
    }
    return total;
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 colorFor(int i, float length){
    float iteration =  float(i)-(log(log(length)/log(2))/ log(3.0));
    //iteration = pow(iteration, 2);
    float brightness = iteration/20;
    vec3 rgb = hsv2rgb(vec3(brightness,1.0,1.0));
    return vec4(rgb.x, rgb.y, rgb.z, 1);
}

void main()
{
    vec2 iResolution = uSize;
    vec2 fragCoord = FlutterFragCoord();
   
    // Normalized pixel coordinates (from 0 to 1)
    float res = min(iResolution.x, iResolution.y);
    vec2 pos = uPos;
    vec2 uv = vec2(0,0);
    vec2 z0 = vec2(0,0);
    
    if (brotOrJulia > 0.0){
        uv = mousePos; 
        z0 = pos+(2.0*((fragCoord-(iResolution/2.0))/res)/zoom); 
    }
    else {
        uv = pos+(2.0*((fragCoord-(iResolution/2.0))/res)/zoom);
        z0 = uv;
    }
    fragColor = vec4(0.0,0.0,0.0,1.0);
    for (int i=0; i<Iterations; i++){
       if (length(z0) > 256){
            fragColor = colorFor(i, length(z0));
            break;
       }
       z0 = vec2(interpret(exprX,z0), interpret(exprY,z0)) + uv;
       
    }
}