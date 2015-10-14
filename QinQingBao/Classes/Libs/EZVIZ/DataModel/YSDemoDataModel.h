//
//  YSDemoDataModel.h
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDemoDataModel : NSObject

+ (instancetype)sharedInstance;

- (NSString *)userAccessToken;

- (void)saveUserAccessToken:(NSString *)token;

@end
