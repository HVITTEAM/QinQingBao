//
//  BonjourBrowser.h
//  SimpleWifi
//
//  Created by yudan on 14-3-19.
//  Copyright (c) 2014年 yudan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BONJOURSEARCH_DEFAULT_TYPE      @"_http._tcp."
#define BONJOURSEARCH_DEFAULT_DOMIN     @"local"
#define BONJOURSEARCH_DEFAULT_TIMEOUT   60


@protocol BonjourBrowserDelegate <NSObject>

@optional

/**
 *   完成搜索
 *
 *  @param arrBonjourServer 设备信息集合
 */
- (void)finishSearchBonjourServer:(NSArray *)arrBonjourServer;

/**
 *  bonjour搜索超时
 */
- (void)TimeourSearchBonjourServer;

@end

@interface BonjourBrowser : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *domain;

@property (nonatomic, weak) id<BonjourBrowserDelegate> delegate;


- (instancetype)initForType:(NSString *)type       // The Bonjour service type to browse for, e.g. @"_http._tcp"
                   inDomain:(NSString *)domain     // The initial domain to browse in (pass nil
                    timeout:(NSTimeInterval)timeInterval; // bonjour search timeout time, default BONJOURSEARCH_DEFAULT_TIMEOUT

// 开始bonjour搜索
- (void)startBonjour;

// 停止bonjour 搜索  
- (void)stopBonjour;

// 当前是否搜索中  
- (BOOL)isBonjouring;

/**
 *  开始bonjour搜索
 *
 *  @param timeout 超时时间
 */
- (void)startBonjour:(NSTimeInterval)timeInterval;

@end
