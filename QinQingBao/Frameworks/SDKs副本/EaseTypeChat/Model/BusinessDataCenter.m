//
//  BusinessDataCenter.m
//  QinQingBao
//
//  Created by Dual on 16/1/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BusinessDataCenter.h"

@implementation BusinessDataCenter

+(id)sharedBusinessDataCenter {
    static BusinessDataCenter *businessDataCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        businessDataCenter = [[self alloc] init];
    });
    return businessDataCenter;
}
-(id)init {
    if (self = [super init]) {
        self.businessDataDic = [NSMutableDictionary dictionary];
    }
    return self;
}






@end
