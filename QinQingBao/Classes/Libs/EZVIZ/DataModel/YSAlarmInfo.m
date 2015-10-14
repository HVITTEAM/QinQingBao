//
//  YSAlarmInfo.m
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSAlarmInfo.h"

@implementation YSAlarmInfo


- (void)setAlarmInfoFromDict:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        NSString *alarmId = [dictionary objectForKey:@"alarmId"];
        if (alarmId)
        {
            if ([alarmId isKindOfClass:[NSString class]]){
                self.alarmId = alarmId;
            }
        }
        
        NSString *alarmName = [dictionary objectForKey:@"alarmName"];
        if (alarmName){
            if ([alarmName isKindOfClass:[NSString class]]){
                self.alarmName = alarmName;
            }
        }
        
        NSNumber *alarmType = [dictionary objectForKey:@"alarmType"];
        if (alarmType)
        {
            if ([alarmType isKindOfClass:[NSNumber class]]){
                self.alarmType = [alarmType integerValue];
            }
        }
        
        NSString *alarmStart = [dictionary objectForKey:@"alarmStart"];
        if (alarmStart)
        {
            if ([alarmStart isKindOfClass:[NSString class]]){
                self.alarmStart = alarmStart;
            }
        }
      
    }
}

@end
