varying lowp vec2 varyTextCoord;
uniform sampler2D myTexture0;
uniform sampler2D myTexture1;


void main()
{
    if (varyTextCoord.x >= 0.5 && varyTextCoord.y >= 0.5) {
        lowp vec2 test = vec2((varyTextCoord.x - 0.5) / 0.5, (varyTextCoord.y - 0.5) / 0.5);
        gl_FragColor = texture2D(myTexture1, test);
    }
    else {
        gl_FragColor = texture2D(myTexture0, varyTextCoord);
    }
}
