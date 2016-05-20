//
//  SMSVerificationView.h
//  QinQingBao
//
//  Created by shi on 16/5/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSVerificationView : UIView

@property(copy)void(^tapConfirmBtnCallBack)(NSString *);            //点击确认按钮后回调，传回验证码

@property(copy,nonatomic)NSString *phoneNum;          //需要发送验证码的手机号码

+(SMSVerificationView *)showSMSVerificationViewToView:(UIView *)targetView;

-(void)hideSMSVerificationView;

@end
