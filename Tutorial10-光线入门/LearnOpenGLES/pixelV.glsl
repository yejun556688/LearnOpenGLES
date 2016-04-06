uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

attribute vec4 position;
attribute vec3 vNormal;

uniform mat3 normalMatrix;

varying mediump vec3 vEyeSpaceNormal;

void main(void)
{
    gl_Position = projectionMatrix * modelViewMatrix * position;

    vEyeSpaceNormal = normalMatrix * vNormal; //光源变化
//    gl_Position = vec4(1, 1, 1, 1);
}