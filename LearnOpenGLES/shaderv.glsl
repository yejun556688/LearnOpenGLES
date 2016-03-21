attribute vec4 position;
attribute vec2 textCoordinate;

varying lowp vec2 varyTextCoord;

void main()
{
    varyTextCoord = textCoordinate;
    gl_Position = position;// + vec4(0.1, 0.1, 0.1, 0);
}