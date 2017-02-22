//
//  ArchiveData.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveData : NSObject

@property (nonatomic, copy) NSString *fmno;

/**档案创建者***/
@property (nonatomic, copy) NSString *creatememberid;

/**姓名***/
@property (nonatomic, copy) NSString *truename;
/**性别 0:保密 1:男 2:女***/
@property (nonatomic, copy) NSString *sex;
/**生日***/
@property (nonatomic, copy) NSString *birthday;
/**身高***/
@property (nonatomic, copy) NSString *height;
/**体重***/
@property (nonatomic, copy) NSString *weight;
/**腰围***/
@property (nonatomic, copy) NSString *waistline;
/**收缩压***/
@property (nonatomic, copy) NSString *systolicpressure;
/**胆固醇***/
@property (nonatomic, copy) NSString *cholesterol;
/**手机号***/
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;

/**目前职业***/
@property (nonatomic, copy) NSString *occupation;
/**生活状态 1.体力劳动为主； 2.脑力劳动为主；3.体力/脑力劳动记得均衡***/
@property (nonatomic, copy) NSString *livingcondition;
/**所属单位***/
@property (nonatomic, copy) NSString *units;
@property (nonatomic, copy) NSString *bremark;
/**当前身体情况***/
@property (nonatomic, copy) NSString *physicalcondition;
/**个人健康方面的重大事件***/
@property (nonatomic, copy) NSString *events;
/**服用药物***/
@property (nonatomic, copy) NSString *takingdrugs;
/**是否患有糖尿病 0：没有 1：患有***/
@property (nonatomic, copy) NSString *diabetes;
/**既往病史***/
@property (nonatomic, copy) NSString *medicalhistory;
/**父母亲是否有心血管病史 0：没有 1：有***/
@property (nonatomic, copy) NSString *hereditarycardiovascular;
/**遗传病***/
@property (nonatomic, copy) NSString *geneticdisease;
/**备注***/
@property (nonatomic, copy) NSString *dremark;
/**吸烟 1.无；2.偶尔；3.0.5包；4.1包；5.大于2包***/
@property (nonatomic, copy) NSString *smoke;
/**喝酒 1.无；2.偶尔；3.经常；***/
@property (nonatomic, copy) NSString *drink;
/**饮食习惯 1.荤素均衡、2.清淡、3.素食、4.重口味、5.嗜甜、6.嗜咖啡、7.爱喝茶、8.爱喝碳酸饮料、9.偏肉食***/
@property (nonatomic, copy) NSArray *diet;
/**睡觉时间***/
@property (nonatomic, copy) NSString *sleeptime;
/**起床时间***/
@property (nonatomic, copy) NSString *getuptime;
/**运动 1.无、2.偶尔、3.经常***/
@property (nonatomic, copy) NSString *sports;
/**不良习惯 1.无、2.久坐、3.经常熬夜、4.长看手机***/
@property (nonatomic, copy) NSArray *badhabits;
/**备注***/
@property (nonatomic, copy) NSString *hremark;


/**报告图片路径,新建时候的本地缓存路径***/
@property (nonatomic, copy) NSMutableArray *reportPhotos;

/**头像路径,新建时候的本地缓存路径***/
@property (nonatomic, copy) NSString *portraitPic;

/**头像路径,查看时候使用,服务器上的头像图片***/
@property (nonatomic, copy) NSString *avatar;

/**报告图片路径,查看时候使用,服务器上***/
@property (nonatomic, copy) NSArray *medical_report;

/**头像***/
@property (nonatomic, copy) UIImage *avatarImage;

@property (nonatomic, copy) NSString *area_id;

@property (nonatomic, copy) NSString *totalname;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *server_organization;



- (void)saveArchiveDataToFile;
- (void)deleteArchiveData;
+ (ArchiveData *)getArchiveDataFromFile;
+ (NSString *)savePictoDocument:(NSData *)imageData picName:(NSString *)picName;
+ (void)deletePicFromDocumentWithPicPath:(NSString *)picPath;

+ (NSInteger)sexToNumber:(NSString *)sexStr;
+ (NSString *)numberToSex:(NSInteger)sexCode;

+ (NSInteger)livingconditionToNumber:(NSString *)livingconditionStr;
+ (NSString *)numberToLivingcondition:(NSInteger)livingconditionCode;

+ (NSInteger)smokeToNumber:(NSString *)smokeStr;
+ (NSString *)numberToSmoke:(NSInteger)smokeCode;

+ (NSInteger)drinkToNumber:(NSString *)drinkStr;
+ (NSString *)numberToDrink:(NSInteger)drinkCode;

+ (NSInteger)dietToNumber:(NSString *)dietStr;
+ (NSString *)numberToDiet:(NSInteger)dietCode;

+ (NSInteger)sportsToNumber:(NSString *)sportsStr;
+ (NSString *)numberToSports:(NSInteger)sportsCode;

+ (NSInteger)badhabitsToNumber:(NSString *)badhabitsStr;
+ (NSString *)numberToBadhabits:(NSInteger)badhabitsCode;

@end
