//
//  UserModel.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/22.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_member_id forKey:@"_member_id"];
    [aCoder encodeObject:_key forKey:@"_key"];
    [aCoder encodeObject:_old_id forKey:@"_old_id"];
}

//解码
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super init])
    {
        _member_id = [aDecoder decodeObjectForKey:@"_member_id"];
        _key = [aDecoder decodeObjectForKey:@"_key"];
        _old_id = [aDecoder decodeObjectForKey:@"_old_id"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    UserModel *vo = [[[self class] allocWithZone:zone] init];
    vo.member_id = [self.member_id copyWithZone:zone];
    vo.key = [self.key copyWithZone:zone];
    vo.old_id = [self.old_id copyWithZone:zone];

    return vo;
}


@end
