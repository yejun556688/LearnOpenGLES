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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    GLKView* view = (GLKView *)self.view;
//    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    
//    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
//    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
//    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
//    
//    view.drawableMultisample = GLKViewDrawableMultisample4X;
   
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView* view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_DEPTH_TEST);
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    
    
    
    GLfloat squareVertexData[48] =
    {
        0.5f, 0.5f, -0.9f,    0.0f, 0.0f, 1.0f,   1.0f, 1.0f,
        -0.5f, 0.5f, -0.9f,    0.0f, 0.0f, 1.0f,   0.0f, 1.0f,
        0.5f, -0.5f, -0.9f,    0.0f, 0.0f, 1.0f,   1.0f, 0.0f,
        0.5f, -0.5f, -0.9f,    0.0f, 0.0f, 1.0f,   1.0f, 0.0f,
        -0.5f, 0.5f, -0.9f,    0.0f, 0.0f, 1.0f,   0.0f, 1.0f,
        -0.5f, -0.5f, -0.9f,    0.0f, 0.0f, 1.0f,   0.0f, 0.0f
    };
    
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 0);
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 12);

    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 24);
    
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"png"];
    
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
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
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1f, 10.f);
//    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1.0f, aspect, 1.0f);
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
    glDrawArrays(GL_TRIANGLES, 0, 6);
}


@end
