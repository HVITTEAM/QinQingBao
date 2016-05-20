//
//  SMSVerificationView.m
//  QinQingBao
//
//  Created by shi on 16/5/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SMSVerificationView.h"

@interface SMSVerificationView ()

@property (weak, nonatomic) IBOutlet UITextField *verificationNumTextView;      //验证码输入框

@property (weak, nonatomic) IBOutlet UIButton *fetchNumberBtn;       //获取验证码按钮

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIView *contentBoxView;     //包含输入框，按钮的View

@property (strong,nonatomic)NSTimer *countTimer;

@property (assign,nonatomic)NSInteger secondsOfCount;           //到计时秒数

@end

@implementation SMSVerificationView

#pragma mark - 周期方法
/**
 *  创建一个SMSVerificationView并显示到指定view上
 */
+(SMSVerificationView *)showSMSVerificationViewToView:(UIView *)targetView;
{
    SMSVerificationView *smsView = [[[NSBundle mainBundle] loadNibNamed:@"SMSVerificationView" owner:nil options:nil] lastObject];
    
    smsView.frame = targetView.bounds;
    [targetView addSubview:smsView];
    
    smsView.contentBoxView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    [UIView animateWithDuration:0.3 animations:^{
        smsView.contentBoxView.transform = CGAffineTransformIdentity;
    }];
    
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:smsView selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:smsView selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return smsView;
}

/**
 *  从指定view上删除
 */
-(void)hideSMSVerificationView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentBoxView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.contentBoxView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    //删除监听键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.fetchNumberBtn.layer.cornerRadius = 7.0f;
    self.fetchNumberBtn.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.fetchNumberBtn.layer.borderWidth = 1.0f;
    
    self.cancelBtn.layer.cornerRadius = 7.0f;
    
    self.confirmBtn.layer.cornerRadius = 7.0f;
}

#pragma mark - 事件方法
/**
 *  点击取消按钮
 */
- (IBAction)tapCancleBtnAction:(id)sender
{
    [self hideSMSVerificationView];
}

/**
 *  点击确认按钮
 */
- (IBAction)tapConfirmBtnAction:(id)sender
{
    NSString *verificationNum = self.verificationNumTextView.text;
    
    if (verificationNum == nil || verificationNum.length == 0) {
        [NoticeHelper AlertShow:@"请输入验证码" view:nil];
        return;
    }
    
    if (self.tapConfirmBtnCallBack) {
        self.tapConfirmBtnCallBack(self.verificationNumTextView.text);
    }
    
    [self hideSMSVerificationView];
}

#pragma mark - 到计时相关
/**
 * 点击获取验证码按钮
 */
- (IBAction)tapFetchNumberBtnActio:(id)sender
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    self.secondsOfCount = 60;
    
    self.fetchNumberBtn.enabled = NO;
    [self.fetchNumberBtn setTitleColor:HMColor(220, 220, 220) forState:UIControlStateNormal];
    
    [self fetchNumberFromServices];
    
    
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startCount) userInfo:nil repeats:YES];
}

/**
 *  到计时
 */
-(void)startCount
{
    self.secondsOfCount --;
    
    if (self.secondsOfCount <= 0) {
        [self.fetchNumberBtn setTitle:@"重新获取" forState:UIControlStateNormal];
         self.fetchNumberBtn.enabled = YES;
        [self.fetchNumberBtn setTitleColor:HMColor(235, 124, 38) forState:UIControlStateNormal];
        
        [self.countTimer invalidate];
        self.countTimer = nil;
        return;
    }
    
    [self.fetchNumberBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.secondsOfCount] forState:UIControlStateNormal];
}

#pragma mark - 网络相关
/**
 *  向服务器获取验证码
 */
-(void)fetchNumberFromServices
{
    NSDictionary *params =  @{
                               @"mobile" : self.phoneNum
                              };
    [CommonRemoteHelper RemoteWithUrl:URL_getsafenum parameters:params type:CommonRemoteTypeGet success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 0) {
            [NoticeHelper AlertShow:@"验证码发送成功，注意查收" view:self];
            
        }else{
            [NoticeHelper AlertShow:@"获取验证码失败！" view:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"获取验证码失败" view:self];
    }];

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

@end
