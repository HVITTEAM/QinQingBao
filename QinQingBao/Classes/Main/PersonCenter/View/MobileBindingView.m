//
//  MobileBindingView.m
//  QinQingBao
//
//  Created by shi on 16/6/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define kSecondCount 60

#import "MobileBindingView.h"
#import "MTSMSHelper.h"

@interface MobileBindingView ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;

@property (weak, nonatomic) IBOutlet UITextField *verifyField;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@property (weak, nonatomic) IBOutlet UIView *contentBoxView;    //放置输入框，按钮等内容的View

@property (assign,nonatomic)NSUInteger secondsOfCount;        //到计时秒数

@property (strong,nonatomic)NSTimer *countTimer;               //定时器

@end

@implementation MobileBindingView

#pragma mark - 周期方法
/**
 *  创建一个MobileBindingView并显示到指定view上
 */
+(MobileBindingView *)showMobileBindingViewToView:(UIView *)targetView
{
    MobileBindingView *mobileBindingView = [[[NSBundle mainBundle] loadNibNamed:@"MobileBindingView" owner:nil options:nil] lastObject];
    
    mobileBindingView.frame = targetView.bounds;
    [targetView addSubview:mobileBindingView];
    
    mobileBindingView.contentBoxView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    [UIView animateWithDuration:0.3 animations:^{
        mobileBindingView.contentBoxView.transform = CGAffineTransformIdentity;
    }];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:mobileBindingView selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:mobileBindingView selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return mobileBindingView;
}

/**
 *  从指定view上删除
 */
-(void)hideMobileBindingView
{
    [self endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentBoxView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.contentBoxView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    //删除监听键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.countTimer invalidate];
    self.countTimer = nil;
}

#pragma mark - 事件方法
- (IBAction)cancelBtnClick:(id)sender
{
    if (self.tapCancelBtnCallBack) {
        self.tapCancelBtnCallBack();
    }
    
    [self hideMobileBindingView];
}

/**
 *  确定按钮被点击
 */
- (IBAction)confirmBtnClick:(id)sender
{
    NSString *verificationNum = self.verifyField.text;
    NSString *phoneNum = self.phoneNumField.text;
    
    if (verificationNum.length == 0 || phoneNum.length == 0) {
        [NoticeHelper AlertShow:@"请输入手机号码或验证码" view:nil];
        return;
    }
    
    if (![self validatePhoneNum:self.phoneNumField.text]) {
        [NoticeHelper AlertShow:@"请输入正确的手机号码" view:self];
        return;
    }
    
    if (self.tapConfirmBtnCallBack) {
        self.tapConfirmBtnCallBack(self.phoneNumField.text,self.verifyField.text);
    }
    
    [self hideMobileBindingView];
}

#pragma mark - 到计时相关
/**
 * 点击按钮获取验证码
 */
- (IBAction)verifyBtnClick:(id)sender
{
    if (self.phoneNumField.text.length == 0)
        return [NoticeHelper AlertShow:@"手机号码不能为空" view:nil];
    
    if (![self validatePhoneNum:self.phoneNumField.text]) {
        [NoticeHelper AlertShow:@"请输入正确的手机号码" view:self];
        return;
    }
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    self.secondsOfCount = kSecondCount;
    
    self.verifyBtn.enabled = NO;
    
   [self fetchNumberFromServicesWidthPhoneNum:self.phoneNumField.text];
    
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startCount) userInfo:nil repeats:YES];
}

/**
 *  到计时
 */
-(void)startCount
{
    self.secondsOfCount --;
    
    if (self.secondsOfCount <= 0) {
        [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.verifyBtn.enabled = YES;
        [self.countTimer invalidate];
        self.countTimer = nil;
        return;
    }
    
    [self.verifyBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.secondsOfCount] forState:UIControlStateNormal];
}

#pragma mark - 网络相关
/**
 *  获取验证码
 */
-(void)fetchNumberFromServicesWidthPhoneNum:(NSString *)phoneNum
{
//    NSDictionary *params =  @{
//                               @"mobile" : phoneNum
//                              };
//    [CommonRemoteHelper RemoteWithUrl:URL_getsafenum parameters:params type:CommonRemoteTypeGet success:^(NSDictionary *dict, id responseObject) {
//        
//        if ([dict[@"code"] integerValue] == 0) {
//            [NoticeHelper AlertShow:@"验证码发送成功，注意查收" view:self];
//        }else{
//            [NoticeHelper AlertShow:@"获取验证码失败！" view:self];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [NoticeHelper AlertShow:@"获取验证码失败" view:self];
//    }];
    
    [[MTSMSHelper sharedInstance] getCheckcode:phoneNum];
}

#pragma mark - 键盘处理相关方法

-(void)keyBoardWillShow:(NSNotification *)notification
{
    //获取键盘动画曲线和持续时间和键盘高
    NSDictionary *keyboardDict = [notification userInfo];
    CGRect keybaordFrame = [[keyboardDict objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat keyboardHeight = keybaordFrame.size.height;
    
    NSInteger animationCurve = [[keyboardDict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [[keyboardDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //键盘顶部到屏幕顶部距离
    CGFloat keyboardTopToViewTop = MTScreenH - keyboardHeight;
    
    UIWindow *wd = [UIApplication sharedApplication].keyWindow;
    //当前文本框底部到屏幕顶部距离
    CGRect contentBoxViewFrame = [wd convertRect:self.contentBoxView.frame fromView:self];
    CGFloat contentBoxViewMaxY = CGRectGetMaxY(contentBoxViewFrame);
    
    //条件成立，说明键盘遮挡了文本框
    if (contentBoxViewMaxY + 60 >= keyboardTopToViewTop) {
        
        [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
            self.contentBoxView.transform = CGAffineTransformTranslate(self.contentBoxView.transform, 0, -(contentBoxViewMaxY + 60 - keyboardTopToViewTop));
        } completion:nil];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
        self.contentBoxView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - 工具方法
/**
 *  验证手机号是否合法格式,合法返回YES，否则为NO
 */
-(BOOL)validatePhoneNum:(NSString *)phone
{
    //判断手机号码是否正确
    NSString *expression = @"^1[3578]\\d{9}$";
    NSPredicate *prediccate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",expression];
    return [prediccate evaluateWithObject:phone];
}

@end
