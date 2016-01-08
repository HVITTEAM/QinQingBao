//
//  CityModel.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_dvname forKey:@"_dvname"];
    [aCoder encodeObject:_dvrank forKey:@"_dvrank"];
    [aCoder encodeObject:_dvcode forKey:@"_dvcode"];
}

//解码
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super init])
    {
        _dvname = [aDecoder decodeObjectForKey:@"_dvname"];
        _dvrank = [aDecoder decodeObjectForKey:@"_dvrank"];
        _dvcode = [aDecoder decodeObjectForKey:@"_dvcode"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    CityModel *vo = [[[self class] allocWithZone:zone] init];
    vo.dvname = [self.dvname copyWithZone:zone];
    vo.dvcode = [self.dvcode copyWithZone:zone];
    vo.dvrank = [self.dvrank copyWithZone:zone];
    
    return vo;
}
@end
