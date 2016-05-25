//
//  BusinessInfoModel.m
//  QinQingBao
//
//  Created by Dual on 16/1/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BusinessInfoModel.h"

@implementation BusinessInfoModel
+(id)businessInfo:(NSDictionary *)dic {
    return [[self alloc] initWithBusinessInfo:dic];
}
-(id)initWithBusinessInfo:(NSDictionary *)dic {
    if (self = [super init]) {
        //_code = dic[@"code"];
        _datas = dic[@"datas"];
        _member_id = dic[@"datas"][@"member_id"];
        _member_truename = dic[@"datas"][@"member_truename"];
        if ([_member_truename isKindOfClass:[NSNull class]]) {
            _member_truename = @"";
        }
        _member_name = dic[@"datas"][@"member_name"];
        _member_avatar = dic[@"datas"][@"member_avatar"];
        _orgname = dic[@"datas"][@"orgname"];
        if ([_orgname isKindOfClass:[NSNull class]]) {
            _orgname = @"";
        }
        _role = dic[@"datas"][@"role"];
    }
    return self;
}
@end
