//
//  ArchiveData.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ArchiveData.h"

@implementation ArchiveData

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_truename forKey:@"_truename"];
    [aCoder encodeObject:_sex forKey:@"_sex"];
    [aCoder encodeObject:_birthday forKey:@"_birthday"];
    [aCoder encodeObject:_height forKey:@"_height"];
    [aCoder encodeObject:_weight forKey:@"_weight"];
    [aCoder encodeObject:_waistline forKey:@"_waistline"];
    [aCoder encodeObject:_systolicpressure forKey:@"_systolicpressure"];
    [aCoder encodeObject:_cholesterol forKey:@"_cholesterol"];
    [aCoder encodeObject:_mobile forKey:@"_mobile"];
    [aCoder encodeObject:_email forKey:@"_email"];
    [aCoder encodeObject:_address forKey:@"_address"];
    [aCoder encodeObject:_occupation forKey:@"_occupation"];
    [aCoder encodeObject:_livingcondition forKey:@"_livingcondition"];
    [aCoder encodeObject:_units forKey:@"_units"];
    [aCoder encodeObject:_bremark forKey:@"_bremark"];
    [aCoder encodeObject:_physicalcondition forKey:@"_physicalcondition"];
    [aCoder encodeObject:_events forKey:@"_events"];
    [aCoder encodeObject:_takingdrugs forKey:@"_takingdrugs"];
    [aCoder encodeObject:_diabetes forKey:@"_diabetes"];
    [aCoder encodeObject:_medicalhistory forKey:@"_medicalhistory"];
    [aCoder encodeObject:_hereditarycardiovascular forKey:@"_hereditarycardiovascular"];
    [aCoder encodeObject:_geneticdisease forKey:@"_geneticdisease"];
    [aCoder encodeObject:_dremark forKey:@"_dremark"];
    [aCoder encodeObject:_smoke forKey:@"_smoke"];
    [aCoder encodeObject:_drink forKey:@"_drink"];
    [aCoder encodeObject:_diet forKey:@"_diet"];
    [aCoder encodeObject:_sleeptime forKey:@"_sleeptime"];
    [aCoder encodeObject:_getuptime forKey:@"_getuptime"];
    [aCoder encodeObject:_sports forKey:@"_sports"];
    [aCoder encodeObject:_badhabits forKey:@"_badhabits"];
    [aCoder encodeObject:_hremark forKey:@"_hremark"];
}

//解码
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super init])
    {
        _truename = [aDecoder decodeObjectForKey:@"_truename"];
        _sex = [aDecoder decodeObjectForKey:@"_sex"];
        _birthday = [aDecoder decodeObjectForKey:@"_birthday"];
        _height = [aDecoder decodeObjectForKey:@"_height"];
        _weight = [aDecoder decodeObjectForKey:@"_weight"];
        _waistline = [aDecoder decodeObjectForKey:@"_waistline"];
        _systolicpressure = [aDecoder decodeObjectForKey:@"_systolicpressure"];
        _cholesterol = [aDecoder decodeObjectForKey:@"_cholesterol"];
        _mobile = [aDecoder decodeObjectForKey:@"_mobile"];
        _email = [aDecoder decodeObjectForKey:@"_email"];
        _address = [aDecoder decodeObjectForKey:@"_address"];
        _occupation = [aDecoder decodeObjectForKey:@"_occupation"];
        _livingcondition = [aDecoder decodeObjectForKey:@"_livingcondition"];
        _units = [aDecoder decodeObjectForKey:@"_units"];
        _bremark = [aDecoder decodeObjectForKey:@"_bremark"];
        _physicalcondition = [aDecoder decodeObjectForKey:@"_physicalcondition"];
        _events = [aDecoder decodeObjectForKey:@"_events"];
        _takingdrugs = [aDecoder decodeObjectForKey:@"_takingdrugs"];
        _diabetes = [aDecoder decodeObjectForKey:@"_diabetes"];
        _medicalhistory = [aDecoder decodeObjectForKey:@"_medicalhistory"];
        _hereditarycardiovascular = [aDecoder decodeObjectForKey:@"_hereditarycardiovascular"];
        _geneticdisease = [aDecoder decodeObjectForKey:@"_geneticdisease"];
        _dremark = [aDecoder decodeObjectForKey:@"_dremark"];
        _smoke = [aDecoder decodeObjectForKey:@"_smoke"];
        _drink = [aDecoder decodeObjectForKey:@"_drink"];
        _diet = [aDecoder decodeObjectForKey:@"_diet"];
        _sleeptime = [aDecoder decodeObjectForKey:@"_sleeptime"];
        _getuptime = [aDecoder decodeObjectForKey:@"_getuptime"];
        _sports = [aDecoder decodeObjectForKey:@"_sports"];
        _badhabits = [aDecoder decodeObjectForKey:@"_badhabits"];
        _hremark = [aDecoder decodeObjectForKey:@"_hremark"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    ArchiveData *vo = [[[self class] allocWithZone:zone] init];
    vo.truename = [self.truename copyWithZone:zone];
    vo.sex = [self.sex copyWithZone:zone];
    vo.birthday = [self.birthday copyWithZone:zone];
    vo.height = [self.height copyWithZone:zone];
    vo.weight = [self.weight copyWithZone:zone];
    vo.waistline = [self.waistline copyWithZone:zone];
    vo.systolicpressure = [self.systolicpressure copyWithZone:zone];
    vo.cholesterol = [self.cholesterol copyWithZone:zone];
    vo.mobile = [self.mobile copyWithZone:zone];
    vo.email = [self.email copyWithZone:zone];
    vo.address = [self.address copyWithZone:zone];
    vo.occupation = [self.occupation copyWithZone:zone];
    vo.livingcondition = [self.livingcondition copyWithZone:zone];
    vo.units = [self.units copyWithZone:zone];
    vo.bremark = [self.bremark copyWithZone:zone];
    vo.physicalcondition = [self.physicalcondition copyWithZone:zone];
    vo.events = [self.events copyWithZone:zone];
    vo.takingdrugs = [self.takingdrugs copyWithZone:zone];
    vo.diabetes = [self.diabetes copyWithZone:zone];
    vo.medicalhistory = [self.medicalhistory copyWithZone:zone];
    vo.hereditarycardiovascular = [self.hereditarycardiovascular copyWithZone:zone];
    vo.geneticdisease = [self.geneticdisease copyWithZone:zone];
    vo.dremark = [self.dremark copyWithZone:zone];
    vo.smoke = [self.smoke copyWithZone:zone];
    vo.drink = [self.drink copyWithZone:zone];
    vo.diet = [self.diet copyWithZone:zone];
    vo.sleeptime = [self.sleeptime copyWithZone:zone];
    vo.getuptime = [self.getuptime copyWithZone:zone];
    vo.sports = [self.sports copyWithZone:zone];
    vo.badhabits = [self.badhabits copyWithZone:zone];
    vo.hremark = [self.hremark copyWithZone:zone];
    
    return vo;
}
@end
