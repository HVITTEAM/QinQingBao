//
//  CommonRemoteHelper.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/16.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonRemoteHelper.h"
@interface CommonRemoteHelper()

@end

@implementation CommonRemoteHelper

static NSOperationQueue * _queue;


+ (void)setCompletionBlockWithUrl:(NSString *)url
                          success:(void (^)(NSDictionary *dict, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURL *urlStr = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        success(dict,responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    [_queue addOperation:operation];
}

//  = HTTP请求格式 =
//  ------------------------------
//  * 请求方法 (GET、POST等)       *
//  * 请求头   (HttpHeaderFields) *
//  * 请求正文 (数据)              *
//  ------------------------------
+(void)RemoteWithUrl:(NSString *)url  parameters:(id)parameters  type:(CommonRemoteType)type
             success:(void (^)(NSDictionary *dict, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置回复内容信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    if (type == CommonRemoteTypePost)
    {
        // 请求的方法
        [manager POST:url
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSString *html = operation.responseString;
                  NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                  NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                  success(dict,responseObject);
                  
                  // 请求头部信息(我们执行网络请求的时候给服务器发送的包头信息)
                  NSLog(@"%@", operation.request.allHTTPHeaderFields);
                  
                  // 服务器给我们返回的包得头部信息
                  NSLog(@"%@", operation.response);
                  
                  // 返回的数据
                  NSLog(@"%@", responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(operation,error);
              }];
    }
    else if (type == CommonRemoteTypeGet)
    {
        // 请求的方法
        [manager GET:url
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSString *html = operation.responseString;
                 NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                 success(dict,responseObject);
                 
                 // 请求头部信息(我们执行网络请求的时候给服务器发送的包头信息)
                 NSLog(@"%@", operation.request.allHTTPHeaderFields);
                 
                 // 服务器给我们返回的包得头部信息
                 NSLog(@"%@", operation.response);
                 
                 // 返回的数据
                 NSLog(@"%@", responseObject);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 failure(operation,error);
             }];
    }
}
@end
