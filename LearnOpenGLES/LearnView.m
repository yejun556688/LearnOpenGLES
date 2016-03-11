//
//  LearnView.m
//  LearnOpenGLES
//
//  Created by 林伟池 on 16/3/11.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LearnView.h"

@implementation LearnView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    glClearColor(0.0f, 0.0f, 0.1f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    GLfloat squareVertexData[] =
    {
        0.0, 1.0, -6.0,
        -1.0, -1.0, -6.0,
        1.0, -1.0, -6.0
    };
    
    
    
}


@end
