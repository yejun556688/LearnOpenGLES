//
//  ViewController.m
//  LearnOpenGLES
//
//  Created by 林伟池 on 16/3/11.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic , strong) EAGLContext* context;
@property (nonatomic , strong) GLKBaseEffect* effect;

@property (nonatomic , assign) GLuint myProgram;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    //新建OpenGLES 上下文
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView* view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_DEPTH_TEST);
    
    
    
    GLfloat squareVertexData[48] =
    {
        0.5, -0.5, 0.0f,    0.0f, 0.0f, 1.0f,   1.0f, 0.0f, //右下
        -0.5, 0.5, -0.0f,    0.0f, 0.0f, 1.0f,   0.0f, 1.0f, //左上
        -0.5, -0.5, -0.0f,    0.0f, 0.0f, 1.0f,   0.0f, 0.0f, //左下
        
        0.5, 0.5, -0.0f,    0.0f, 0.0f, 1.0f,   1.0f, 1.0f, //右上
//        -0.5f, 0.5f, -0.0f,    0.0f, 0.0f, 1.0f,   0.0f, 1.0f, //左上
//        0.5f, -0.5f, -0.0f,    0.0f, 0.0f, 1.0f,   1.0f, 0.0f //右下
    };
    
    
    GLubyte indices[] =
    {
        0, 1, 2,
        1, 3, 0
    };

    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 0);

    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 12);

    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 24);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"png"];
    
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  场景数据变化
 */
- (void)update {
    CGSize size = self.view.bounds.size;
    float aspect = fabsf(size.width / size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), 1.0f, 0.1f, 10.f);
    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1.0f, 1.0f, 1.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -1.0f);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}


/**
 *  渲染场景代码
 *
 *  @param view <#view description#>
 *  @param rect <#rect description#>
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    glDrawElements(GL_TRIANGLES, 6,GL_UNSIGNED_BYTE, 0);
//    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    

}

@end
