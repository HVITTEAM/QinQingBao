//
//  MTSMSHelper.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDKCountryAndAreaCode.h>

@interface MTSMSHelper : NSObject<UIAlertViewDelegate>

@property(nonatomic,retain) NSString* areaCode;

@property(nonatomic,retain) NSString* telNum;

/** 点击确定发送的回调函数 */
@property (nonatomic, copy) void (^sureSendSMS)();


+(MTSMSHelper *)sharedInstance;

/**
 * 发送验证码
 **/
-(void)getCheckcode:(NSString *)telNumber;

/**
 * 验证是否通过
 **/
-(BOOL)checkCode:(NSString *)telNumber;
@end
