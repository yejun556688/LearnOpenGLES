attribute vec3 position;
attribute vec2 textCoordinate;
uniform mat4 rotateMatrix;

varying lowp vec2 varyTextCoord;

void main()
{
    varyTextCoord = textCoordinate;
    
    vec4 vPos = vec4(position, 1);

    vPos = vPos * rotateMatrix;

    gl_Position = vPos;
}