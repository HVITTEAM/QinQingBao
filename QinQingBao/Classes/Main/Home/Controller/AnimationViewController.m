//
//  AnimationViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/18.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()
{
    double angle;
}
@property (nonatomic, retain) UIImageView *xcodeImageView;

@end

@implementation AnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *xcodeImage = [UIImage imageNamed:@"MTReflesh.png"];
    self.xcodeImageView = [[UIImageView alloc] initWithImage:xcodeImage];
    //设置图片的Frame
    [self.xcodeImageView setFrame:CGRectMake(0.0f,0.0f, 40.0f, 40.0f)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.xcodeImageView];
    
    self.xcodeImageView.center = self.view.center;
    
    angle = 10;
    [self startAnimation];
}

-(void) startAnimation
{
    /* Begin the animation */
    [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
    /* Make the animation 5 seconds long */
    [UIView setAnimationDuration:0.001f];
    [UIView setAnimationDelegate:self];
    //停止动画时候调用clockwiseRotationStopped方法
    [UIView setAnimationDidStopSelector:@selector(clockwiseRotationStopped:finished:context:)];
    //顺时针旋转90度
    self.xcodeImageView.transform = CGAffineTransformMakeRotation((angle * M_PI) / 180.0f);
    /* Commit the animation */
    [UIView commitAnimations];
}

- (void)clockwiseRotationStopped:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished
                         context:(void *)paramContext{
//    [UIView beginAnimations:@"counterclockwiseAnimation"context:NULL];
//    /* 5 seconds long */
//    [UIView setAnimationDuration:0.5f];
//    /* 回到原始旋转 */
//    self.xcodeImageView.transform = CGAffineTransformIdentity;
//    [UIView commitAnimations];
    
    angle += 10;
    [self startAnimation];
}

@end
