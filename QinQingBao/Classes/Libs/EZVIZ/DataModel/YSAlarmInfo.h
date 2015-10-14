//
//  YSAlarmInfo.h
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSAlarmInfo : NSObject

@property (nonatomic, copy) NSString *alarmId;           // 消息唯一标识
@property (nonatomic, copy) NSString *alarmName;         // 报警源名称
@property (nonatomic, assign) NSInteger alarmType;         // 报警类型
@property (nonatomic, copy) NSString *alarmStart;        // 报警开始时间

- (void)setAlarmInfoFromDict:(NSDictionary *)dictionary;

@end
