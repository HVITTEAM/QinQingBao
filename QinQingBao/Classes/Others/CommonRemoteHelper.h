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

+(void)UploadPicWithUrl:(NSString *)url  parameters:(id)parameters  type:(CommonRemoteType)type
                dataObj:(NSData *)dataObj success:(void (^)(NSDictionary *dict, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  imageArray数组中的元素为NSDictionary对象，需要有4个key-value，对应的 key为:
 *   @"fileData":二进制文件,@"name":名字需与服务器对应,@"fileName":文件名,@"mimeType":数据的类型
 */
+(void)UploadPicWithUrl:(NSString *)url
             parameters:(id)parameters
                   type:(CommonRemoteType)type
                 images:(NSArray *)imageArray
                success:(void (^)(NSDictionary *dict, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end