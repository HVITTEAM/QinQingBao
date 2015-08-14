//
//  MTSMSHelper.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>

@interface MTSMSHelper : NSObject<UIAlertViewDelegate>

@property(nonatomic,retain) NSString* areaCode;

@property(nonatomic,retain) NSString* telNum;

/** 点击确定发送的回调函数 */
@property (nonatomic, copy) void (^sureSendSMS)();

/**
 * 获取支持的地区列表
 **/
-(void)setTheLocalAreaCode;

/**
 * 发送验证码
 **/
-(void)getCheckcode:(NSString *)telNumber;

/**
 * 验证是否通过
 **/
-(BOOL)checkCode:(NSString *)telNumber;
@end
