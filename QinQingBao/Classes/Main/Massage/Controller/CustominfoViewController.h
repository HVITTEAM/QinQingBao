//
//  CustominfoViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/4/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"

@interface CustominfoViewController : HMCommonViewController

+ (instancetype)itemWithName:(NSString *)name phpne:(NSString *)phpne;
@property (nonatomic, copy) void (^inforClick)(NSString *name,NSString *telnum);



@end
