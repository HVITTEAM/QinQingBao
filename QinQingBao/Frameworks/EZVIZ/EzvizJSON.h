//
//  EzvizJSON.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 15/5/27.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EzvizJSON)

/**
 *  JSON字符串到NSDictionary对象解析
 *
 *  @return NSDictionary对象
 */
- (NSDictionary *)ezvizJSONValue;

/**
 *  根据解析方式将JSON字符串到NSDictionary对象解析
 *
 *  @param options 解析方式选项
 *
 *  @return NSDictionary对象
 */
- (NSDictionary *)ezvizJSONValue:(NSJSONReadingOptions)options;

@end

@interface NSDictionary (EzvizJSON)

/**
 *  NSDictionary对象解析成JSON字符串
 *
 *  @return JSON字符串
 */
- (NSString *)ezvizJSONString;

/**
 *  根据解析方式将NSDictionary对象解析成JSON字符串
 *
 *  @param options 解析方式选项
 *
 *  @return JSON字符串
 */
- (NSString *)ezvizJSONString:(NSJSONWritingOptions)options;

@end