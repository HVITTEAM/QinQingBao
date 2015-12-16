//
//  CommonRemoteHelper.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/16.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonRemoteHelper.h"
#import "Networking.h"

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
    manager.requestSerializer.timeoutInterval = 20;
    if (type == CommonRemoteTypePost)
    {
        // 请求的方法
        [manager POST:url
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = operation.responseString;
                  NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                  NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                  if (dict == nil)
                  {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"返回值为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                      [alertView show];
                      success(dict,responseObject);
                  }
                  else
                  {
                      success(dict,responseObject);
                  }
                  // 请求头部信息(我们执行网络请求的时候给服务器发送的包头信息)
                  //                  NSLog(@"%@", operation.request.allHTTPHeaderFields);
                  
                  // 服务器给我们返回的包得头部信息
                  //                  NSLog(@"%@", operation.response);
                  
                  // 返回的数据
                  //                  NSLog(@"%@", responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                  [alertView show];
                  NSLog(@"出错了......");
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

+(void)UploadPicWithUrl:(NSString *)url  parameters:(id)parameters  type:(CommonRemoteType)type
                dataObj:(NSData *)dataObj success:(void (^)(NSDictionary *dict, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [Networking UploadDataWithUrlString:URL_UploadAvatar
                             parameters:parameters
                        timeoutInterval:nil
                            requestType:HTTPRequestType
                           responseType:JSONResponseType
              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                  // 构造数据的地方
                  [formData appendPartWithFileData:dataObj name:@"pic" fileName:@"img.png" mimeType:@"image/png"];
              }
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSString *html = operation.responseString;
                                    NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                                    NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                                    success(dict,responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failure(operation,error);
                                }];
}
@end
