//
//  CommonRemoteHelper.h
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/16.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, CommonRemoteType) {
    CommonRemoteTypePost,
    CommonRemoteTypeGet,
};

@interface CommonRemoteHelper : NSObject

+ (void)setCompletionBlockWithUrl:(NSString *)url
                          success:(void (^)(NSDictionary *dict, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)RemoteWithUrl:(NSString *)url  parameters:(id)parameters  type:(CommonRemoteType)type
             success:(void (^)(NSDictionary *dict, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
