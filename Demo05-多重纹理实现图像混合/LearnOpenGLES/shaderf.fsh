varying lowp vec2 varyTextCoord;
varying lowp vec2 varyOtherPostion;

uniform lowp vec2 leftBottom;
uniform lowp vec2 rightTop;

uniform sampler2D myTexture0;
uniform sampler2D myTexture1;


void main()
{
    if (varyOtherPostion.x >= leftBottom.x && varyOtherPostion.y >= leftBottom.y && varyOtherPostion.x <= rightTop.x && varyOtherPostion.y <= rightTop.y) {
        
        lowp vec2 test = vec2((varyOtherPostion.x - leftBottom.x) / (rightTop.x - leftBottom.x), 1.0 -  (varyOtherPostion.y - leftBottom.y) / (rightTop.y - leftBottom.y));
        gl_FragColor = texture2D(myTexture1, test);
    }
    else {
        gl_FragColor = texture2D(myTexture0, varyTextCoord);
    }
}
