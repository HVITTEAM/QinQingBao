//
//  MarketCustomInfo.m
//  QinQingBao
//
//  Created by shi on 16/8/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketCustomInfo.h"

@implementation MarketCustomInfo

+(NSInteger)sexToNumber:(NSString *)sex
{
    if ([sex isEqualToString:@"男"]) {
        return 1;
    }else if ([sex isEqualToString:@"女"]){
        return 2;
    }else{
        return 3;
    }
}

+(NSString *)numberToSex:(NSInteger)number
{
    NSString *sex;
    switch (number) {
        case 1:
            sex = @"男";
            break;
        case 2:
            sex = @"女";
            break;
        default:
            sex = @"保密";
            break;
    }
    
    return sex;
}

+(NSInteger)womanSpecialToNumber:(NSString *)womanSpecial
{
    if ([womanSpecial isEqualToString:@"无"]) {
        return 0;
    }else{
        return 1;
    }
}


@end
