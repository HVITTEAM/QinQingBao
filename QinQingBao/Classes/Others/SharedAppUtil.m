//
//  sharedAppUtil.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "SharedAppUtil.h"

@implementation SharedAppUtil

+(SharedAppUtil *)defaultCommonUtil
{
    static SharedAppUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[SharedAppUtil alloc]init];
    });
    return util;
}

-(void)setLat:(NSString *)lat
{
    if (lat.length == 0 )
        _lat = @"";
    _lat = lat;
}

-(void)setLon:(NSString *)lon
{
    if (lon.length == 0 )
        lon = @"";
    _lon = lon;
}

-(UserModel *)userVO
{
    return _userVO;
}

//////// 特殊字符的限制输入，价格金额的有效性判断

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSCharacterSet *cs;
//    if ([textField isEqual:textfield1_]) {
//        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL basicTest = [string isEqualToString:filtered];
//        if (!basicTest) {
//            [self showMyMessage:@"只能输入数字"];
//            return NO;
//        }
//    }
//    else if ([textField isEqual:textfield2_]) {
//        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL basicTest = [string isEqualToString:filtered];
//        if (!basicTest) {
//            [self showMyMessage:@"只能输入数字"];
//            return NO;
//        }
//    }
//    else if ([textField isEqual:textfield3_]) {
//        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
//        if (NSNotFound == nDotLoc && 0 != range.location) {
//            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
//        }
//        else {
//            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
//        }
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL basicTest = [string isEqualToString:filtered];
//        if (!basicTest) {
//            
//            [self showMyMessage:@"只能输入数字和小数点"];
//            return NO;
//        }
//        if (NSNotFound != nDotLoc && range.location > nDotLoc + 3) {
//            [self showMyMessage:@"小数点后最多三位"];
//            return NO;
//        }
//    }
//    return YES;
//}
@end
