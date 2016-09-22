//
//  BBSUserModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BBSUserModel.h"

@implementation BBSUserModel
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_BBS_Member_id forKey:@"_BBS_Member_id"];
    [aCoder encodeObject:_BBS_Key forKey:@"_BBS_Key"];
    [aCoder encodeObject:_BBS_Member_mobile forKey:@"_BBS_Member_mobile"];
    [aCoder encodeObject:_BBS_Sys forKey:@"_BBS_Sys"];
}


//解码
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super init])
    {
        _BBS_Member_id = [aDecoder decodeObjectForKey:@"_BBS_Member_id"];
        _BBS_Key = [aDecoder decodeObjectForKey:@"_BBS_Key"];
        _BBS_Member_mobile = [aDecoder decodeObjectForKey:@"_BBS_Member_mobile"];
        _BBS_Sys = [aDecoder decodeObjectForKey:@"_BBS_Sys"];
        
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    BBSUserModel *vo = [[[self class] allocWithZone:zone] init];
    
    vo.BBS_Member_id = [self.BBS_Member_id copyWithZone:zone];
    vo.BBS_Key = [self.BBS_Key copyWithZone:zone];
    vo.BBS_Member_mobile = [self.BBS_Member_mobile copyWithZone:zone];
    vo.BBS_Sys = [self.BBS_Sys copyWithZone:zone];
    
    return vo;
}

@end
