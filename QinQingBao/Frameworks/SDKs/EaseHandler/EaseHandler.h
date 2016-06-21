//
//  EaseHandler.h
//  QinQingBao
//
//  Created by Dual on 15/12/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"
#import "EMError.h"
@interface EaseHandler : NSObject
-(void)registerAndLoginEase:(NSString *)userName;//注册并登录
-(void)registerEaseMobWithUserName:(NSString *)userName;//注册
-(void)loginEaseMobWithUserName:(NSString *)userName;//登录
-(void)logoutEaseMobCallBack;//退出
-(void)toStringWithEaseMobError:(EMError *)error;//错误处理
@end
