//
//  LoginInHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "LoginInHeadView.h"
#define kRefreshHeaderRotateAnimationKey @"RotateAnimationKey"
static const CGFloat criticalY = -50.f;
@interface LoginInHeadView ()
{
    UIImageView *markView;
}

@end
@implementation LoginInHeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.letterBtn.hidden = YES;
    self.followBtn.hidden = YES;
    self.userIcon.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginHandler:)];
    [self.userIcon addGestureRecognizer:singleTap];

    //加v
    markView = [[UIImageView alloc] init];
    markView.image = [UIImage imageNamed:@"v.png"];
    markView.hidden = YES;
    [self addSubview:markView];

    self.professionLab.layer.cornerRadius = 4;
    self.professionLab.layer.masksToBounds = YES;
    
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        [self.loginBtn setTitle:@" 未登录 " forState:UIControlStateNormal];
        self.professionLab.text = @"";
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userIcon.layer.cornerRadius = self.userIcon.width / 2;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.borderColor = HMColor(148, 191, 54).CGColor;
    self.userIcon.layer.borderWidth = 3.0f;
    markView.frame = CGRectMake(CGRectGetMaxX(self.userIcon.frame) - 20, CGRectGetMaxY(self.userIcon.frame) - 20, 16, 16);
}

-(void)initWithName:(NSString *)name professional:(NSString *)professional isfriend:(NSString *)isfriend  is_mine:(NSString *)is_mine
{
    if (is_mine && [is_mine integerValue] == 1)
    {
        self.letterBtn.hidden = YES;
        self.followBtn.hidden = YES;
    }
    else if(is_mine && [is_mine integerValue] == 0)
    {
        self.letterBtn.hidden = NO;
        self.followBtn.hidden = NO;
    }
    
    [self.loginBtn setTitle:name forState:UIControlStateNormal];
    
    if (!professional || professional.length == 0)
    {
        markView.hidden = YES;
        self.professionLab.text = @"";
    }
    else
    {
        markView.hidden = NO;
        self.professionLab.text = [NSString stringWithFormat:@" %@ ",professional];
    }
    
    if (isfriend && [isfriend integerValue] == 0)
    {
        self.followBtn.tag = 1;
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    }
    else if (isfriend && [isfriend integerValue] == 1)
    {
        self.followBtn.tag = 0;
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"nofollow.png"] forState:UIControlStateNormal];
    }
}

#pragma mark 个人中心操作模块

- (IBAction)loginHandler:(id)sender {
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    
    if (self.inforClick) {
        self.inforClick();
    }
}


#pragma mark 用户资料操作模块

- (IBAction)letterHandler:(id)sender {
    if (self.navbtnClick) {
        UIButton *btn = (UIButton *)sender;
        self.navbtnClick(btn.tag);
    }
}

- (IBAction)followHandler:(id)sender {
    if (self.navbtnClick) {
        UIButton *btn = (UIButton *)sender;
        self.navbtnClick(btn.tag);
    }
}

-(void)setStates:(RefreshViewState)states
{
    _states = states;
    if (states == RefreshViewStateRefreshing)
    {
        CABasicAnimation *_rotateAnimation;
        _rotateAnimation = [[CABasicAnimation alloc] init];
        _rotateAnimation.keyPath = @"transform.rotation.z";
        _rotateAnimation.fromValue = @0;
        _rotateAnimation.toValue = @(M_PI * 2);
        _rotateAnimation.duration = 1.0;
        _rotateAnimation.repeatCount = MAXFLOAT;
        [self.refleshBtn.layer addAnimation:_rotateAnimation forKey:kRefreshHeaderRotateAnimationKey];
    }
    else if (states == RefreshViewStateNormal)
    {
        self.refleshBtn.alpha = 0;
        [self.refleshBtn.layer removeAnimationForKey:kRefreshHeaderRotateAnimationKey];
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(refleshWithStates:)]) {
        [self.delegate refleshWithStates:self.states];
    }
}

- (void)updateRefreshHeaderWithOffsetY:(CGFloat)y scrollView:(UIScrollView*)scrollView
{
    CGFloat rotateValue = y / 50.0 * M_PI;
    
    if (y < criticalY) {
        y = criticalY;
        
        if (scrollView.isDragging && self.states != RefreshViewStateWillRefresh) {
            self.states = RefreshViewStateWillRefresh;
        } else if (!scrollView.isDragging && self.states == RefreshViewStateWillRefresh) {
            self.states = RefreshViewStateRefreshing;
        }
    }
    
    if (self.states == RefreshViewStateRefreshing) return;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, -y);
    transform = CGAffineTransformRotate(transform, rotateValue);
    
    self.refleshBtn.transform = transform;
    
}

@end
