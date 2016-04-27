//
//  AdvanceViewController.m
//  LearnOpenGLES
//
//  Created by 林伟池 on 16/3/25.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AdvanceViewController.h"
#import "starship.h"


@interface AdvanceViewController ()
{
    float   _rotate;
}

@property (nonatomic , strong) EAGLContext* mContext;

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) GLKSkyboxEffect *skyboxEffect;
@property (assign, nonatomic, readwrite) GLKVector3 eyePosition;
@property (assign, nonatomic) GLKVector3 lookAtPosition;
@property (assign, nonatomic) GLKVector3 upVector;
@property (assign, nonatomic) float angle;

@property (nonatomic , strong) UISwitch* mPauseSwitch;
@end


@implementation AdvanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView* view = (GLKView *)self.view;
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.mContext];
    
    self.eyePosition = GLKVector3Make(0.0, 10.0, 10.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.0, 0.0);
    self.upVector = GLKVector3Make(0.0, 1.0, 0.0);
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.position = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
    self.baseEffect.light0.specularColor = GLKVector4Make(0.25f, 0.25f, 0.25f, 1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.75f, 0.75f, 0.75f, 1.0f);
    self.baseEffect.lightingType = GLKLightingTypePerPixel;
    
    [self setMatrices];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, starshipPositions);
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, starshipNormals);
    
    _rotate = 0.0f;
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
    
    NSString *path = [[NSBundle bundleForClass:[self class]]
                      pathForResource:@"image" ofType:@"png"];
    NSAssert(nil != path, @"Path to skybox image not found");
    NSError *error = nil;
    GLKTextureInfo* textureInfo = [GLKTextureLoader
                                   cubeMapWithContentsOfFile:path
                                   options:nil
                                   error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    // Create and configure skybox
    self.skyboxEffect = [[GLKSkyboxEffect alloc] init];
    self.skyboxEffect.textureCubeMap.name = textureInfo.name;
    self.skyboxEffect.textureCubeMap.target = textureInfo.target;
    if (textureInfo.target == GL_TEXTURE_2D) {
        NSLog(@"GL_TEXTURE_2D");
    }
    else {
        NSLog(@"CUBE");
    }
    self.skyboxEffect.xSize = 6.0f;
    self.skyboxEffect.ySize = 6.0f;
    self.skyboxEffect.zSize = 6.0f;
    
    //
    self.mPauseSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 30, 44, 44)];
    [self.view addSubview:self.mPauseSwitch];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setMatrices
{
    const GLfloat aspectRatio = (GLfloat)(self.view.bounds.size.width) / (GLfloat)(self.view.bounds.size.height);
    self.baseEffect.transform.projectionMatrix =
    GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0f),// Standard field of view
                              aspectRatio,
                              0.1f,   // Don't make near plane too close
                              20.0f); // Far arbitrarily far enough to contain scene
    
    {
        self.baseEffect.transform.modelviewMatrix =
        GLKMatrix4MakeLookAt(
                             self.eyePosition.x,      // Eye position
                             self.eyePosition.y,
                             self.eyePosition.z,
                             self.lookAtPosition.x,   // Look-at position
                             self.lookAtPosition.y,
                             self.lookAtPosition.z,
                             self.upVector.x,         // Up direction
                             self.upVector.y,
                             self.upVector.z);
        
        // Orbit slowly around ship model just to see the
        // scene change
        if (!self.mPauseSwitch.on) {
            self.angle += 0.01;
        }
        self.eyePosition = GLKVector3Make(10.0f * sinf(self.angle),
                                          10.0f,
                                          10.0f * cosf(self.angle));
        
        // Pitch up and down slowly to marvel at the sky and water
        self.lookAtPosition = GLKVector3Make(0.0,
                                             1.5 + 5.0f * sinf(0.3 * self.angle),
                                             0.0);
        
    }
}

- (void)update {
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self setMatrices];
    
    
    self.skyboxEffect.center = self.eyePosition;
    self.skyboxEffect.transform.projectionMatrix = self.baseEffect.transform.projectionMatrix;
    self.skyboxEffect.transform.modelviewMatrix = self.baseEffect.transform.modelviewMatrix;
    [self.skyboxEffect prepareToDraw];
    glDepthMask(false);
    [self.skyboxEffect draw];
    glDepthMask(true);
    
    for(int i=0; i<starshipMaterials; i++)
    {
        // 设置材质
        self.baseEffect.material.diffuseColor = GLKVector4Make(starshipDiffuses[i][0], starshipDiffuses[i][1], starshipDiffuses[i][2], 1.0f);
        self.baseEffect.material.specularColor = GLKVector4Make(starshipSpeculars[i][0], starshipSpeculars[i][1], starshipSpeculars[i][2], 1.0f);
        
//        [self.baseEffect prepareToDraw];
        
//        glDrawArrays(GL_TRIANGLES, starshipFirsts[i], starshipCounts[i]);
    }
    
}
@end

