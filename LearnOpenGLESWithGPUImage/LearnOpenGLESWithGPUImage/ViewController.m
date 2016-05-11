//
//  ViewController.m
//  LearnOpenGLESWithGPUImage
//
//  Created by 林伟池 on 16/5/10.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"
#import <GPUImageView.h>
#import <GPUImage/GPUImageSepiaFilter.h>

@interface ViewController ()
@property (nonatomic , strong) UIImageView* mImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    self.mImageView = imageView;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 200, 100, 100)];
    [button setTitle:@"change" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onCustom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self onCustom:nil];
}

- (void)onCustom:(id)sender {
    static Boolean flag;
    if (flag) {
        flag = !flag;
        GPUImageSepiaFilter* filter = [[GPUImageSepiaFilter alloc] init];
        UIImage* image = [UIImage imageNamed:@"face"];
        [self.mImageView setImage:[filter imageByFilteringImage:image]];
        
    }
    else {
        flag = !flag;
        self.mImageView.image = [[[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"custom"] imageByFilteringImage:[UIImage imageNamed:@"face"]];
        //    NSLog(@"%@", [[NSBundle mainBundle] pathForResource:@"custom" ofType:@"fsh"]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
