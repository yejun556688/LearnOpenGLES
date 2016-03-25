//
//  ViewController.m
//  LearnOpenGLES
//
//  Created by 林伟池 on 16/3/11.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;

@property (nonatomic , assign) int mCount;
@end

@implementation ViewController
{
    dispatch_source_t timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   

    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* view = (GLKView *)self.view;
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.mContext];
    glEnable(GL_DEPTH_TEST);
    
    
    //顶点数据
    GLfloat squareVertexData[48] =
    {
        0.5, -0.5, 0.0f,    0.0f, 0.0f, 1.0f,   1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 0.0f, 1.0f,   0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,    0.0f, 0.0f, 1.0f,   0.0f, 0.0f, //左下
        
        0.5, 0.5, -0.0f,    0.0f, 0.0f, 1.0f,   1.0f, 1.0f, //右上
    };

    //顶点索引
    GLuint indices[] =
    {
        0, 1, 2,
        1, 3, 0
    };
    self.mCount = sizeof(indices) / sizeof(GLuint);

    
    //顶点数据缓存
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 0);

    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 12);

    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 24);

    
    //纹理贴图
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"png"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.light0.enabled = GL_TRUE;
    self.mEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  场景数据变化
 */
- (void)update {
    
    //投影变换
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), aspect, 0.1f, 10.f);
    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1.0f, 1.0f, 1.0f);
    self.mEffect.transform.projectionMatrix = projectionMatrix;
    
    //z轴平移
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
    self.mEffect.transform.modelviewMatrix = modelViewMatrix;
}


/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.mCount, GL_UNSIGNED_INT, 0);
}

@end
