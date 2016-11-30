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
    [aCoder encodeObject:_reportPhotos forKey:@"_reportPhotos"];
    [aCoder encodeObject:_portraitPic forKey:@"_portraitPic"];
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
        _reportPhotos = [aDecoder decodeObjectForKey:@"_reportPhotos"];
        _portraitPic = [aDecoder decodeObjectForKey:@"_portraitPic"];
        
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
    vo.reportPhotos = [self.reportPhotos copy];
    vo.portraitPic = [self.portraitPic copy];
    return vo;
}

- (NSMutableArray *)reportPhotos
{
    if (!_reportPhotos) {
        _reportPhotos = [[NSMutableArray alloc] init];
    }
    
    return _reportPhotos;
}

- (void)saveArchiveDataToFile
{
    NSString *filePath = [ArchiveData getArchiveFilePath];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

- (void)deleteArchiveData
{
    NSString *directoryPath = [ArchiveData getArchiveDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:directoryPath error:NULL];
}

+ (ArchiveData *)getArchiveDataFromFile
{
    NSString *filePath = [ArchiveData getArchiveFilePath];
    ArchiveData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return data;
}

+ (NSString *)getArchiveFilePath
{
    NSString *fileDirectory = [ArchiveData getArchiveDirectory];
    return [NSString stringWithFormat:@"%@/%@_archive",fileDirectory,[SharedAppUtil defaultCommonUtil].userVO.member_id];
}

+ (NSString *)getArchiveDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileDirectory = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"archive/%@",[SharedAppUtil defaultCommonUtil].userVO.member_id]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir;
    
    if ([manager fileExistsAtPath:fileDirectory isDirectory:&isDir]) {
        if (!isDir) {
            [manager removeItemAtPath:fileDirectory error:NULL];
            [manager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }else{
        [manager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return fileDirectory;
}

+ (NSString *)savePictoDocument:(NSData *)imageData picName:(NSString *)picName
{
    NSString *fileDirectory = [ArchiveData getArchiveDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileDirectory,picName];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    [imageData writeToFile:filePath atomically:YES];
    return filePath;
}

+ (void)deletePicFromDocumentWithPicPath:(NSString *)picPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:picPath error:NULL];
}

//性别 0:保密 1:男 2:女
+ (NSInteger)sexToNumber:(NSString *)sexStr
{
    if ([sexStr isEqualToString:@"男"]) {
        return 1;
    }else if ([sexStr isEqualToString:@"女"]){
        return 2;
    }else{
        return 0;
    }
}

+ (NSString *)numberToSex:(NSInteger)sexCode
{
    NSString *sex = nil;
    switch (sexCode) {
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

//生活状态 1.体力劳动为主； 2.脑力劳动为主；3.体力/脑力劳动记得均衡
+ (NSInteger)livingconditionToNumber:(NSString *)livingconditionStr
{
    if ([livingconditionStr isEqualToString:@"体力劳动为主"]) {
        return 1;
    }else if ([livingconditionStr isEqualToString:@"脑力劳动为主"]){
        return 2;
    }else if ([livingconditionStr isEqualToString:@"体力/脑力劳动基本均衡"]){
        return 3;
    }else{
        return -1;
    }
}

+ (NSString *)numberToLivingcondition:(NSInteger)livingconditionCode
{
    NSString *livingcondition = nil;
    switch (livingconditionCode) {
        case 1:
            livingcondition = @"体力劳动为主";
            break;
        case 2:
            livingcondition = @"脑力劳动为主";
            break;
        case 3:
            livingcondition = @"体力/脑力劳动基本均衡";
            break;
        default:
            livingcondition = nil;
            break;
    }
    return livingcondition;
}


//吸烟 1.无；2.偶尔；3.0.5包；4.1包；5.大于2包
+ (NSInteger)smokeToNumber:(NSString *)smokeStr
{
    if ([smokeStr isEqualToString:@"无"]) {
        return 1;
    }else if ([smokeStr isEqualToString:@"偶尔"]){
        return 2;
    }else if ([smokeStr isEqualToString:@"半包"]){
        return 3;
    }else if ([smokeStr isEqualToString:@"一包"]){
        return 4;
    }else if ([smokeStr isEqualToString:@"一包以上"]){
        return 5;
    }else{
        return -1;
    }
}

+ (NSString *)numberToSmoke:(NSInteger)smokeCode
{
    NSString *smoke = nil;
    switch (smokeCode) {
        case 1:
            smoke = @"无";
            break;
        case 2:
            smoke = @"偶尔";
            break;
        case 3:
            smoke = @"半包";
            break;
        case 4:
            smoke = @"一包";
            break;
        case 5:
            smoke = @"一包以上";
            break;
        default:
            smoke = nil;
            break;
    }
    return smoke;
}

//喝酒 1.无；2.偶尔；3.经常
+ (NSInteger)drinkToNumber:(NSString *)drinkStr
{
    if ([drinkStr isEqualToString:@"无"]) {
        return 1;
    }else if ([drinkStr isEqualToString:@"偶尔"]){
        return 2;
    }else if ([drinkStr isEqualToString:@"经常"]){
        return 3;
    }else{
        return -1;
    }
}

+ (NSString *)numberToDrink:(NSInteger)drinkCode
{
    NSString *drink = nil;
    switch (drinkCode) {
        case 1:
            drink = @"无";
            break;
        case 2:
            drink = @"偶尔";
            break;
        case 3:
            drink = @"经常";
            break;
        default:
            drink = nil;
            break;
    }
    return drink;
}

/**饮食习惯 1.荤素均衡、2.清淡、3.素食、4.重口味、5.嗜甜、6.嗜咖啡、7.爱喝茶、8.爱喝碳酸饮料***/
+ (NSInteger)dietToNumber:(NSString *)dietStr
{
    if ([dietStr isEqualToString:@"荤素均衡"]) {
        return 1;
    }else if ([dietStr isEqualToString:@"清淡"]){
        return 2;
    }else if ([dietStr isEqualToString:@"素食"]){
        return 3;
    }else if ([dietStr isEqualToString:@"重口味"]){
        return 4;
    }else if ([dietStr isEqualToString:@"嗜甜"]){
        return 5;
    }else if ([dietStr isEqualToString:@"嗜咖啡"]){
        return 6;
    }else if ([dietStr isEqualToString:@"爱喝茶"]){
        return 7;
    }else if ([dietStr isEqualToString:@"碳酸饮料"]){
        return 8;
    }else{
        return -1;
    }
}

+ (NSString *)numberToDiet:(NSInteger)dietCode
{
    NSString *diet = nil;
    switch (dietCode) {
        case 1:
            diet = @"荤素均衡";
            break;
        case 2:
            diet = @"清淡";
            break;
        case 3:
            diet = @"素食";
            break;
        case 4:
            diet = @"重口味";
            break;
        case 5:
            diet = @"嗜甜";
            break;
        case 6:
            diet = @"嗜咖啡";
            break;
        case 7:
            diet = @"爱喝茶";
            break;
        case 8:
            diet = @"碳酸饮料";
            break;
        default:
            diet = nil;
            break;
    }
    return diet;
}

/**运动 1.无、2.偶尔、3.经常***/
+ (NSInteger)sportsToNumber:(NSString *)sportsStr
{
    if ([sportsStr isEqualToString:@"无"]) {
        return 1;
    }else if ([sportsStr isEqualToString:@"偶尔"]){
        return 2;
    }else if ([sportsStr isEqualToString:@"经常"]){
        return 3;
    }
    else{
        return -1;
    }
}

+ (NSString *)numberToSports:(NSInteger)sportsCode
{
    NSString *sports = nil;
    switch (sportsCode) {
        case 1:
            sports = @"无";
            break;
        case 2:
            sports = @"偶尔";
            break;
        case 3:
            sports = @"经常";
            break;
        default:
            sports = nil;
            break;
    }
    return sports;
}

/**不良习惯 1.无、2.久坐、3.经常熬夜、4.长看手机***/
+ (NSInteger)badhabitsToNumber:(NSString *)badhabitsStr
{
    if ([badhabitsStr isEqualToString:@"无"]) {
        return 1;
    }else if ([badhabitsStr isEqualToString:@"久坐"]){
        return 2;
    }else if ([badhabitsStr isEqualToString:@"经常熬夜"]){
        return 3;
    }else if ([badhabitsStr isEqualToString:@"常看手机"]){
        return 4;
    }else{
        return -1;
    }
}

+ (NSString *)numberToBadhabits:(NSInteger)badhabitsCode
{
    NSString *badhabits = nil;
    switch (badhabitsCode) {
        case 1:
            badhabits = @"无";
            break;
        case 2:
            badhabits = @"久坐";
            break;
        case 3:
            badhabits = @"经常熬夜";
            break;
        case 4:
            badhabits = @"常看手机";
            break;
        default:
            badhabits = nil;
            break;
    }
    return badhabits;
}

@end
