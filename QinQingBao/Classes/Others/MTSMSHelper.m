//
//  MTSMSHelper.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MTSMSHelper.h"

@interface MTSMSHelper ()
{
    SMSSDKCountryAndAreaCode* _data2;
    NSString* _str;
    NSMutableArray* _areaArray;
}

@end

@implementation MTSMSHelper

+(MTSMSHelper *)sharedInstance
{
    static MTSMSHelper *smsHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        smsHelper = [[MTSMSHelper alloc] init];
    });
    return smsHelper;
}

/**
 * 验证是否通过
 **/
-(BOOL)checkCode:(NSString *)telNumber
{
    __block BOOL state;
    [SMSSDK commitVerificationCode:telNumber phoneNumber:telNumber zone:_areaCode result:^(NSError *error) {
        if (!error)
        {
            NSLog(@"验证成功");
            state = YES;
        }
        else
        {
            NSLog(@"错误信息:%@",error);
            state = NO;
        }
    }];
    return state;
}

/**
 * 发送验证码
 **/
-(void)getCheckcode:(NSString *)telNumber
{
    self.areaCode = @"86";
    self.telNum = telNumber;
    
    int compareResult = 0;
    for (int i=0; i<_areaArray.count; i++)
    {
        NSDictionary* dict1=[_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[self.areaCode stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult=1;
            NSString* rule1=[dict1 valueForKey:@"rule"];
            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch=[pred evaluateWithObject:telNumber];
            if (!isMatch)
            {
                //手机号码不正确
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                              message:NSLocalizedString(@"手机号码错误", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"好", nil)
                                                    otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            break;
        }
    }
    
    if (!compareResult)
    {
        if (telNumber.length!=11)
        {
            //手机号码不正确
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                          message:NSLocalizedString(@"手机号码错误", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"好", nil)
                                                otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    NSString* str=[NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"我们将发送验证码到这个号码", nil),self.areaCode,telNumber];
    _str=[NSString stringWithFormat:@"%@",telNumber];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确认手机号码", nil)
                                                  message:str delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                        otherButtonTitles:NSLocalizedString(@"好", nil), nil];
    [alert show];
}

/**
 * 选择是否确定发送
 **/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
        NSString* str2=[self.areaCode stringByReplacingOccurrencesOfString:@"+" withString:@"+86"];
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telNum zone:str2 customIdentifier:nil result:^(NSError *error) {
            if (!error)
            {
                //倒计时
                if (self.sureSendSMS)
                {
                    self.sureSendSMS();
                }
            }
            else
            {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                              message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.code,error.localizedFailureReason]
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                    otherButtonTitles:nil, nil];
                [alert show];
                
                NSLog(@"错误信息:%@",error);
            }
            
        }];
    }
}


@end
