varying lowp vec2 varyTextCoord;

uniform sampler2D colorMap;


void main()
{
    gl_FragColor = vec4(0, 0, 0, 1);
    if (gl_FragCoord.x > 160.0) {
        gl_FragColor = vec4(1, 0, 1, 1);
    }
    if (true) {
        gl_FragColor = texture2D(colorMap, varyTextCoord);
    }
}