//
//  CRecInfo.h
//  iVMSTest
//
//  Created by hikvision on 12-12-28.
//  Copyright (c) 2012年 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoGoDef.h"

//typedef struct
//{
//	int year;
//	int month;
//	int day;
//	int hour;
//	int minute;
//	int second;
//}ABSTIME, *PABSTIME;

@interface CRecInfo : NSObject
{
    ABSTIME  starTime;
    ABSTIME  stopTime;
}

@property ABSTIME  starTime;
@property ABSTIME  stopTime;

@end
