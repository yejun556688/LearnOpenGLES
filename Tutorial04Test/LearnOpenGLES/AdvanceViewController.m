//
//  AdvanceViewController.m
//  LearnOpenGLES
//
//  Created by 林伟池 on 16/3/25.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AdvanceViewController.h"

@interface AdvanceViewController ()

@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;
@property (nonatomic , strong) GLKBaseEffect* mMirrorEffect;

@property (nonatomic , assign) float mDegreeX;
@property (nonatomic , assign) float mDegreeY;
@property (nonatomic , assign) float mDegreeZ;


@property (nonatomic , assign) BOOL mBoolX;
@property (nonatomic , assign) BOOL mBoolY;
@property (nonatomic , assign) BOOL mBoolZ;

@property (nonatomic , assign) int mCount;
@property (nonatomic , assign) GLuint mAttr;
@property (nonatomic , assign) GLuint mIndicesAttr;
@property (nonatomic , assign) GLuint mMirrorAttr;
@end

@implementation AdvanceViewController
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
    
    //新的图形
    [self renderNew];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderNew {
    
    //顶点数据，前三个是顶点坐标， 中间三个是顶点颜色，    最后两个是纹理坐标
    GLfloat attrArr[] =
    {
        -0.5f, 0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       0.0f, 1.0f,//左上
        0.5f, 0.5f, 0.0f,       0.0f, 0.5f, 0.0f,       1.0f, 1.0f,//右上
        -0.5f, -0.5f, 0.0f,     0.5f, 0.0f, 1.0f,       0.0f, 0.0f,//左下
        0.5f, -0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       1.0f, 0.0f,//右下
        0.0f, 0.0f, 1.0f,       1.0f, 1.0f, 1.0f,       0.5f, 0.5f,//顶点
    };
    //顶点索引
    GLuint indices[] =
    {
        0, 3, 2,
        0, 1, 3,
        0, 2, 4,
        0, 4, 1,
        2, 3, 4,
        1, 4, 3,
    };
    self.mCount = sizeof(indices) / sizeof(GLuint);
    
    GLfloat mirrorAttr[] =
    {
        -0.5f, -0.5f, 0.0f,            0.0f, 0.0f,//左下
        0.5f, -0.5f, 0.0f,             1.0f, 0.0f,//右下
        -0.5f, 0.5f, 0.0f,             0.0f, 1.0f,//左上
        0.5f, 0.5f, 0.0f,              1.0f, 1.0f,//右上
    };
    
    
    glGenBuffers(1, &_mMirrorAttr);
    glBindBuffer(GL_ARRAY_BUFFER, _mMirrorAttr);
    glBufferData(GL_ARRAY_BUFFER, sizeof(mirrorAttr), mirrorAttr, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_mAttr);
    glBindBuffer(GL_ARRAY_BUFFER, _mAttr);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_mIndicesAttr);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _mIndicesAttr);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL);
    //顶点颜色
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL + 3);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL + 6);
    
    
    //纹理
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"png"];
    
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    //着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
    
    self.mMirrorEffect = [[GLKBaseEffect alloc] init];
    self.mMirrorEffect.texture2d0.enabled = GL_TRUE;
    self.mMirrorEffect.texture2d0.name = textureInfo.name;
    
    
    
    //初始的投影
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), aspect, 0.1f, 10.f);
    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1.0f, 1.0f, 1.0f);
    self.mEffect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
    self.mEffect.transform.modelviewMatrix = modelViewMatrix;
    
    
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(120.0), aspect, 0.1f, 10.f);
    self.mMirrorEffect.transform.projectionMatrix = projectionMatrix;
    modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 2.0f, -2.0f);
    self.mMirrorEffect.transform.modelviewMatrix = GLKMatrix4RotateX(modelViewMatrix, 0.0);
    
    //定时器
    double delayInSeconds = 0.1;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC, 0.0);
    dispatch_source_set_event_handler(timer, ^{
        self.mDegreeX += 0.1  * self.mBoolX;
        self.mDegreeY += 0.1 * self.mBoolY;
        self.mDegreeZ += 0.1 * self.mBoolZ;
        
    });
    dispatch_resume(timer);
}

-(IBAction)onX:(id)sender {
    self.mBoolX = !self.mBoolX;
}

-(IBAction)onY:(id)sender {
    self.mBoolY = !self.mBoolY;
}

-(IBAction)onZ:(id)sender {
    self.mBoolZ = !self.mBoolZ;
}


/**
 *  场景数据变化
 */
- (void)update {
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
    
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, self.mDegreeX);
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, self.mDegreeY);
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, self.mDegreeZ);
    
    self.mEffect.transform.modelviewMatrix = modelViewMatrix;
}


/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // mirror
    glBindBuffer(GL_ARRAY_BUFFER, self.mMirrorAttr);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL);
    
    glBindBuffer(GL_ARRAY_BUFFER, self.mMirrorAttr);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    [self.mMirrorEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    
    // base
    glBindBuffer(GL_ARRAY_BUFFER, self.mAttr);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL + 3);
    [self.mEffect prepareToDraw];
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _mIndicesAttr);
    glDrawElements(GL_TRIANGLES, self.mCount, GL_UNSIGNED_INT, 0);
    
}


@end
