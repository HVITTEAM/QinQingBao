//
//  LoginInHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "LoginInHeadView.h"
#define kRefreshHeaderRotateAnimationKey @"RotateAnimationKey"

@implementation LoginInHeadView

-(void)awakeFromNib
{
    self.letterBtn.hidden = YES;
    self.followBtn.hidden = YES;
    self.userIcon.layer.cornerRadius = self.userIcon.width/2;
    self.userIcon.layer.masksToBounds = YES;
    
    self.professionLab.layer.cornerRadius = 4;
    self.professionLab.layer.masksToBounds = YES;
    
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        self.loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.loginBtn.layer.borderWidth = .5f;
        self.loginBtn.layer.cornerRadius = 5;
        self.loginBtn.layer.masksToBounds = YES;
        
        [self.loginBtn setTitle:@" 未登录 " forState:UIControlStateNormal];
        
        self.professionLab.text = @"";
    }
}
//
//-(void)setIsUserata:(BOOL)isUserata
//{
//    _isUserata = isUserata;
//    if (isUserata)
//    {
//        self.letterBtn.hidden = NO;
//        self.followBtn.hidden = NO;
//    }
//    else
//    {
//        self.letterBtn.hidden = YES;
//        self.followBtn.hidden = YES;
//    }
//}

-(void)initWithName:(NSString *)name professional:(NSString *)professional isfriend:(NSString *)isfriend  is_mine:(NSString *)is_mine
{
    if (is_mine && [is_mine integerValue] == 1)
    {
        self.letterBtn.hidden = YES;
        self.followBtn.hidden = YES;
    }
    else
    {
        self.letterBtn.hidden = NO;
        self.followBtn.hidden = NO;
    }
    
    [self.loginBtn setTitle:name forState:UIControlStateNormal];
    
    if (!professional || professional.length == 0)
        self.professionLab.text = @"";
    else
        self.professionLab.text = [NSString stringWithFormat:@" %@ ",professional];
    
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


-(void)setRefleshStates:(RefreshViewState)states
{
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
}

@end
