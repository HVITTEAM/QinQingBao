//
//  EzvizBonjourManager.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 15/6/25.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EzvizBonjourManagerDelegate;

@interface EzvizBonjourManager : NSObject

@property (nonatomic, weak) id<EzvizBonjourManagerDelegate> delegate;

+ (instancetype)shareManager;

- (void)bonjourSearchStartWithTypes:(NSArray *)types;

- (void)bonjourSearchStop;

@end

@protocol EzvizBonjourManagerDelegate <NSObject>

- (void)localServiceClientList:(NSArray *)list;

@end