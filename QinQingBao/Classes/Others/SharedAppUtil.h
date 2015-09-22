//
//  sharedAppUtil.h 系统缓存
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  单例保存app的用户信息

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface SharedAppUtil : NSObject

+(SharedAppUtil *)defaultCommonUtil;

@property (nonatomic, retain) UserModel *userVO;

@end
