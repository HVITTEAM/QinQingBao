//
//  EzvizGlobalKit.m
//  EzvizOpenSDKDemo
//
//  Created by DeJohn Dong on 15/7/15.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import "EzvizDemoGlobalKit.h"

@implementation EzvizDemoGlobalKit

+ (instancetype)sharedKit{
    static EzvizDemoGlobalKit *kit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kit = [[EzvizDemoGlobalKit alloc] init];
    });
    return kit;
}

- (instancetype)init{
    self = [super init];
    if(self){
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"EzvizOAuthToken"];
    }
    return self;
}

- (void)setToken:(NSString *)token{
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:_token?:@"" forKey:@"EzvizOAuthToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
