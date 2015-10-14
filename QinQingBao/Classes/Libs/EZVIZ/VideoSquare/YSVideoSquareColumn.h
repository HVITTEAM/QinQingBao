//
//  YSVideoSquareColumn.h
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/19/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSVideoSquareColumn : NSObject

// 频道值
@property (nonatomic, copy) NSString *channelCode;

// 频道名称
@property (nonatomic, copy) NSString *channelName;

// 频道级别
@property (nonatomic, copy) NSString *channelLevel;

// 父频道值
@property (nonatomic, copy) NSString *parentId;

// 显示顺序【升序】
@property (nonatomic, copy) NSString *showFlag;

@end
