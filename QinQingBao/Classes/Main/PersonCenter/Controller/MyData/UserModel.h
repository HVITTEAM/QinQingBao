//
//  UserModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/22.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *old_id;
@property (nonatomic, copy) NSString *imei_watch;
@property (nonatomic, copy) NSString *member_mobile;
//登录类型 默认为正常登录 分别为 0手机号码 qq：1 微信：2 新浪：3
@property (nonatomic, copy) NSString *logintype;
@property (nonatomic, copy) NSString *pwd;


@end
