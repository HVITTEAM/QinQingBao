//
//  YSCheckSMSCodeViewController.h
//  EzvizRealPlayDemo
//
//  Created by Journey on 12/8/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RegisterCheck = 1 << 0,
    ScheduleCheck = 2 << 1,
} YSCheckType;

@interface YSCheckSMSCodeViewController : UIViewController

@property (nonatomic) YSCheckType type;

@end
