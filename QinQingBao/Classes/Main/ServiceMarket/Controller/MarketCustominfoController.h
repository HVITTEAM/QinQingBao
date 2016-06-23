//
//  MarketCustominfoController.h
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCommonViewController.h"

@interface MarketCustominfoController : HMCommonViewController

@property (copy)void(^inforClick)(NSString *name ,NSString *tel ,NSString *address, NSString *email);

+(instancetype)initWith:(NSString *)name tel:(NSString *)tel address:(NSString *)address email:(NSString *)email;

@end
