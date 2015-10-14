//
//  circleWaitView.m
//  shipin7HD
//
//  Created by yudan on 13-4-27.
//  Copyright (c) 2013年 Dengsh. All rights reserved.
//

#import "circleWaitView.h"


@interface circleWaitView()

// 开始转圈圈
- (void)startCircle;

// 停止转圈圈
- (void)stopCircle;

@end

@implementation circleWaitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initView
{
    CGRect rcView = self.frame;
    CGRect rcImgView = CGRectMake(0, 0, rcView.size.width, rcView.size.height);
    
    _bgView = [[UIImageView alloc] init];
    _bgView.image = [UIImage imageNamed:@"VideoLoding_Bg.png"];
    [self addSubview:_bgView];
    _bgView.frame = rcImgView;
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _lodingView = [[UIImageView alloc] init];
    _lodingView.image = [UIImage imageNamed:@"VideoLoding.png"];
    [self addSubview:_lodingView];
    _lodingView.frame = rcImgView;
    _lodingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}

// 开始转圈圈
- (void)startCircle
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2 , 0, 0, 1)];
    animation.duration = 1;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    [_lodingView.layer addAnimation:animation forKey:ANIMATION_KEY_CIRCLE];
}

// 停止转圈圈
- (void)stopCircle
{
    [_lodingView.layer removeAnimationForKey:ANIMATION_KEY_CIRCLE];
}


// 显示
- (void)show
{
    [self startCircle];
    self.hidden = NO;
}

// 隐藏
- (void)hide
{
    [self stopCircle];
    self.hidden = YES;
}


@end
