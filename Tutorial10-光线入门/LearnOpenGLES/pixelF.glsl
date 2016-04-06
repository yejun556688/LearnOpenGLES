precision mediump float;
varying  vec3 vEyeSpaceNormal;
uniform  vec3 vLightPosition;
uniform  vec3 vAmbientMaterial;

void main()
{    
    vec3 N = normalize(vEyeSpaceNormal);
    
    vec3 L = normalize(vLightPosition);
    
    float df = max(0.0, dot(N, L));
    
    vec3 tmp = vAmbientMaterial + df * vec3(0.5, 0.5, 1.0);
    gl_FragColor = vec4(tmp, 1.0);
}