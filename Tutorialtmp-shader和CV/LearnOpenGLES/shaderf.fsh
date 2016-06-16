varying lowp vec2 varyTextCoord;

uniform sampler2D colorMap;


void main()
{
    lowp vec4 color = texture2D(colorMap, varyTextCoord);
//    color.r = 0.5;
    gl_FragColor = color;
}
