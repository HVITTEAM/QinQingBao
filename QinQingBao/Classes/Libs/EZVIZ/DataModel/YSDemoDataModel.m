//
//  YSDemoDataModel.m
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSDemoDataModel.h"

@interface YSDemoDataModel ()

@property (nonatomic, copy) NSString *accessToken;

@end

@implementation YSDemoDataModel

+ (instancetype)sharedInstance
{
    static YSDemoDataModel *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[YSDemoDataModel alloc] init];
    });
    
    return client;
}


- (NSString *)userAccessToken
{
    return _accessToken;
}

- (void)saveUserAccessToken:(NSString *)token
{
    self.accessToken = token;
}

@end
