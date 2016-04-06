attribute vec4 position;
attribute vec3 vNormal;
//attribute vec4 vDiffuseMaterial;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;


uniform mat3 normalMatrix;
uniform vec3 vLightPosition;
uniform vec4 vAmbientMaterial;

varying lowp vec4 varyColor;

void main()
{
    vec4 vPos;
    vPos = projectionMatrix * modelViewMatrix * position;

    gl_Position = vPos;
    
    
    vec3 N = normalize(normalMatrix * vNormal); //光源固定照着在一点（顶点），所以底面为黑色
    
    vec3 L = normalize(vLightPosition);
    
    float df = max(0.0, dot(N, L));


    varyColor = vAmbientMaterial + df * vec4(0.5, 0.5, 1, 1);// vDiffuseMaterial;
}