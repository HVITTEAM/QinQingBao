//
//  EzvizGlobalKit.h
//  EzvizOpenSDKDemo
//
//  Created by DeJohn Dong on 15/7/15.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EzvizDemoGlobalKit : NSObject

@property (nonatomic, copy) NSString *token;

+ (instancetype)sharedKit;

@end
