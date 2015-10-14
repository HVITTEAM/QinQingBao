//
//  YSCheckSMSCodeViewController.h
//  EzvizRealPlayDemo
//
//  Created by Journey on 12/8/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    RegisteCheck,
    ScheduleCheck
};

typedef NSInteger YSCheckType;

@interface YSCheckSMSCodeViewController : UIViewController

@property (nonatomic, assign) YSCheckType type;

@end
